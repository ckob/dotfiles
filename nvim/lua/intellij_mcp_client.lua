-- ~/.config/nvim/lua/intellij_mcp_client.lua
local M = {}
local curl = require('plenary.curl')

local state = {
    mcp_port = 64342,
    session_url = nil,
    sse_job_id = nil,
    request_counter = 1,
    pending_requests = {},
    namespace = vim.api.nvim_create_namespace("intellij_mcp_diagnostics")
}

-- Helper function for Plenary POST requests
local function send_mcp_request(payload)
    if not state.session_url then return end

    curl.post(state.session_url, {
        body = vim.fn.json_encode(payload),
        headers = { ["Content-Type"] = "application/json" },
        callback = function(res)
            if res.status ~= 200 and res.status ~= 202 then
                vim.schedule(function()
                    vim.notify("MCP Request Failed: " .. res.status, vim.log.levels.ERROR)
                end)
            end
        end
    })
end

-- 1. The Initialization Handshake
local function send_initialize()
    local payload = {
        jsonrpc = "2.0",
        id = 1,
        method = "initialize",
        params = {
            protocolVersion = "2024-11-05",
            capabilities = vim.empty_dict(), -- Fixes the empty JSON array bug
            clientInfo = { name = "intellij-mcp-client.nvim", version = "1.0.0" }
        }
    }
    send_mcp_request(payload)
    vim.schedule(function()
        vim.notify("IntelliJ MCP: Connected & Initialized!", vim.log.levels.INFO)
    end)
end

-- 2. The Real Diagnostic Request
local function request_diagnostics(bufnr)
    if not state.session_url then return end

    local project_path = vim.fn.getcwd()
    local file_path_relative = vim.fn.expand('%:.')

    state.request_counter = state.request_counter + 1
    local req_id = state.request_counter
    state.pending_requests[req_id] = bufnr

    local payload = {
        jsonrpc = "2.0",
        id = req_id,
        method = "tools/call",
        params = {
            name = "get_file_problems",
            arguments = {
                filePath = file_path_relative,
                projectPath = project_path,
                errorsOnly = false,
                timeout = 10000 
            }
        }
    }
    send_mcp_request(payload)
end

-- 3. The "Reformat Hammer" Forced Sync
local function force_rider_sync(bufnr)
    if not state.session_url then return end

    local project_path = vim.fn.getcwd()
    local file_path_relative = vim.fn.expand('%:.')

    -- The Hammer: Force Rider to synchronously read and format the file.
    -- We use a dummy ID (999998) because we don't care about parsing the response.
    local reformat_payload = {
        jsonrpc = "2.0",
        id = 999998, 
        method = "tools/call",
        params = {
            name = "reformat_file",
            arguments = {
                filePath = file_path_relative,
                projectPath = project_path
            }
        }
    }
    send_mcp_request(reformat_payload)

    -- The Fetch: Because formatting is a synchronous, high-priority IDE task, 
    -- ReSharper evaluates the file immediately. A 250ms delay is just to let 
    -- the HTTP JSON payloads travel back and forth smoothly.
    vim.defer_fn(function()
        request_diagnostics(bufnr)
    end, 250)
end

-- 4. Processing the JSON from Rider
local function process_mcp_response(json_str)
    -- Sanitize hidden carriage returns
    json_str = json_str:gsub("[\r\n]", "")
    local ok, parsed = pcall(vim.fn.json_decode, json_str)

    if not ok or not parsed.id or not parsed.result then 
        -- Ignore errors from our 999998 dummy request silently
        return 
    end

    local bufnr = state.pending_requests[parsed.id]
    if not bufnr then return end 

    -- Clean up the pending request
    state.pending_requests[parsed.id] = nil

    local structured = parsed.result.structuredContent
    if not structured or not structured.errors then
        vim.diagnostic.set(state.namespace, bufnr, {})
        return
    end

    local diagnostics = {}
    for _, err in ipairs(structured.errors) do
        local severity = vim.diagnostic.severity.INFO
        if err.severity == "ERROR" then severity = vim.diagnostic.severity.ERROR
        elseif err.severity == "WARNING" then severity = vim.diagnostic.severity.WARN
        elseif err.severity == "WEAK WARNING" then severity = vim.diagnostic.severity.HINT
        end

        table.insert(diagnostics, {
            bufnr = bufnr,
            lnum = err.line - 1,  -- Neovim is 0-indexed
            col = err.column - 1, -- Neovim is 0-indexed
            message = err.description,
            severity = severity,
            source = "IntelliJ",
        })
    end

    vim.diagnostic.set(state.namespace, bufnr, diagnostics)
end

-- 5. The Background Listener (SSE Stream)
local function connect_to_intellij()
    if state.sse_job_id then
        vim.fn.jobstop(state.sse_job_id)
    end

    local url = "http://localhost:" .. state.mcp_port .. "/sse"

    state.sse_job_id = vim.fn.jobstart({"curl", "-N", "-s", url}, {
        stdout_buffered = false,
        on_stdout = function(_, data)
            if not data then return end

            for _, line in ipairs(data) do
                -- Look for the initialization endpoint
                local endpoint = line:match("^data:%s*(/message%?sessionId=.*)")
                if endpoint then
                    endpoint = endpoint:gsub("[\r\n%s]", "")
                    state.session_url = "http://localhost:" .. state.mcp_port .. endpoint
                    send_initialize()
                end

                -- Look for JSON payloads returning from our requests
                local json_str = line:match("^data:%s*({.*})")
                if json_str then
                    process_mcp_response(json_str)
                end
            end
        end,
        on_exit = function()
            state.session_url = nil
            state.sse_job_id = nil
        end
    })
end

-- 6. Setup Function
function M.setup(opts)
    opts = opts or {}
    state.mcp_port = opts.port or 64342

    vim.api.nvim_create_user_command('IntelliJMcpConnect', connect_to_intellij, { 
        desc = "Connect to local IntelliJ IDE via MCP" 
    })

    -- Trigger the hammer on save
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("IntelliJMCP", { clear = true }),
        pattern = "*",
        callback = function(args)
            if state.session_url then
                force_rider_sync(args.buf)
            end
        end
    })
end

return M

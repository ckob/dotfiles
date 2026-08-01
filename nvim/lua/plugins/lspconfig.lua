return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "folke/snacks.nvim",
  },
  config = function()
    require("mason").setup({
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
    })
    require("mason-lspconfig").setup()
    require("mason-tool-installer").setup({
      ensure_installed = {
        "lua_ls",
        "stylua",
        -- "roslyn",
        "copilot-language-server",
        "prettier",
        "ts_ls"
        -- "cucumber-language-server"
      },
    })

    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    })

    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    local lspconfig = require("lspconfig")

    vim.lsp.config("cucumber_language_server", {
      root_dir = lspconfig.util.root_pattern(".git", "Features"),
      settings = {
        cucumber = {
          glue = { "test/**/Steps/**/*.cs" },
          features = { "test/**/Features/**/*.feature" },
        },
      },
    })
    vim.lsp.enable("cucumber_language_server")


    local keymap = vim.keymap
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Rename"
        keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

        opts.desc = "Format"
        keymap.set({ "n", "v" }, "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)

        opts.desc = "Go to previous error"
        keymap.set("n", "[e", function()
          vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
        end, opts)

        opts.desc = "Go to next error"
        keymap.set("n", "]e", function()
          vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
        end, opts)

        opts.desc = "Go to previous warning"
        keymap.set("n", "[w", function()
          vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN, float = true })
        end, opts)

        opts.desc = "Go to next warning"
        keymap.set("n", "]w", function()
          vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN, float = true })
        end, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        -- opts.desc = "Restart LSP"
        -- keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })
  end,
}

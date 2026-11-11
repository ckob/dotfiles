-- ~/.config/rex/init.lua

--------------------------------------------------------------------------------
-- 1. TMUX-STYLE PREFIX ENGINE
--------------------------------------------------------------------------------
local prefix = "ctrl+space"

local function bind_prefix(key, action, args)
  rex.bind(prefix .. ">" .. key, action, args)
end

-- Double-tap the prefix to send literal Ctrl+Space through to the terminal
rex.bind(prefix .. ">" .. prefix, "pane.send_key", { key = prefix })

-- Standard Tmux multiplexer bindings (automatically generated)
bind_prefix("c", "client.tab.new")
bind_prefix("x", "pane.close")
bind_prefix("z", "pane.zoom")

-- Splits (% and " or v and s)
bind_prefix("shift+5", "pane.split", { direction = "right" }) -- %
bind_prefix("shift+'", "pane.split", { direction = "down" })  -- "
bind_prefix("v", "pane.split", { direction = "right" })
bind_prefix("s", "pane.split", { direction = "down" })

-- Directional pane navigation (Vim keys)
bind_prefix("h", "pane.focus.left")
bind_prefix("j", "pane.focus.down")
bind_prefix("k", "pane.focus.up")
bind_prefix("l", "pane.focus.right")

--------------------------------------------------------------------------------
-- 2. HERDR CUSTOM SHORTCUT MIGRATIONS
--------------------------------------------------------------------------------

-- Herdr: last_pane = "prefix+space"
bind_prefix("space", "pane.focus_previous")

-- Herdr: goto = "prefix+/"
-- Rex's equivalent to Herdr's workspace/agent picker is the session switcher
bind_prefix("/", "session.switch")

-- Tabs (Windows in Rex session) navigation: prefix+n / prefix+p
bind_prefix("n", "client.tab.next")
bind_prefix("p", "client.tab.previous")

-- Focus sidebar tab / session filter: prefix+w
bind_prefix("w", "client.sidebar.filter.focus")

--------------------------------------------------------------------------------
-- 3. CUSTOM COMMAND: LAZYGIT POPUP
-- Herdr: [[keys.command]] key = "prefix+g", type = "popup", command = "lazygit"
--------------------------------------------------------------------------------
rex.action({
  name = "lazygit_popup",
  title = "Open Lazygit Popup",
  run = function(ctx)
    local pwd = rex.block.call("com.superlogical.terminal", "pwd", {})
    local cwd = pwd and pwd.pwd and pwd.pwd:gsub("^file://[^/]*", "")

    local focus_cmd = ctx.block_id and string.format("; rex focus %s", ctx.block_id) or ""
    rex.session.new_layer({
      bounds = { 0.05, 0.05, 0.9, 0.9 },
      focus = true,
      layout = rex.layout.block({
        flavor = "com.superlogical.terminal.shell",
        options = {
          cwd = cwd,
          command = { "sh", "-c", "lazygit" .. focus_cmd },
        },
      }),
    })
  end,
})

bind_prefix("g", "lazygit_popup")


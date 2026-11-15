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
-- Close the focused pane, else the tab (like Herdr/tmux last-pane behavior)
bind_prefix("x", "client.close")
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

-- Resize mode (prefix+r, then h/j/k/l to resize, = to balance, esc to exit)
bind_prefix("r", "client.mode.enter", { name = "resize" })
rex.bind("resize/h", "pane.resize", { direction = "left" })
rex.bind("resize/j", "pane.resize", { direction = "down" })
rex.bind("resize/k", "pane.resize", { direction = "up" })
rex.bind("resize/l", "pane.resize", { direction = "right" })
rex.bind("resize/=", "pane.balance")

--------------------------------------------------------------------------------
-- 2. HERDR CUSTOM SHORTCUT MIGRATIONS
--------------------------------------------------------------------------------

-- Herdr: last_pane = "prefix+space"
bind_prefix("space", "pane.focus_previous")

-- Herdr: goto = "prefix+/"
-- Command palette (searches actions, tabs, windows, sessions): prefix+/
bind_prefix("/", "client.palette.toggle")
bind_prefix("[Slash]", "client.palette.toggle")

-- Tabs (Windows in Rex session) navigation: prefix+n / prefix+p
bind_prefix("n", "client.tab.next")
bind_prefix("p", "client.tab.previous")

--------------------------------------------------------------------------------
-- 3. CUSTOM COMMANDS (POPUP OVERLAYS)
--------------------------------------------------------------------------------
local function open_popup(cmd, cwd, block_id)
  local focus_cmd = block_id and string.format("; rex focus %s", block_id) or ""
  rex.session.new_layer({
    bounds = { 0.05, 0.05, 0.9, 0.9 },
    focus = true,
    layout = rex.layout.block({
      flavor = "com.superlogical.terminal.shell",
      options = {
        cwd = cwd,
        command = { "sh", "-c", cmd .. focus_cmd },
      },
    }),
  })
end

-- Herdr: [[keys.command]] key = "prefix+g", type = "popup", command = "lazygit"
rex.action({
  name = "lazygit_popup",
  title = "Open Lazygit Popup",
  run = function(ctx)
    local pwd = rex.block.call("com.superlogical.terminal", "pwd", {})
    local cwd = pwd and pwd.pwd and pwd.pwd:gsub("^file://[^/]*", "")
    open_popup("lazygit", cwd, ctx.block_id)
  end,
})

bind_prefix("g", "lazygit_popup")

-- Herdr: prefix+e (open pane scrollback in Neovim for visual/copy mode)
rex.action({
  name = "scrollback_editor",
  title = "Open Scrollback in Neovim",
  run = function(ctx)
    if not ctx.block_id then
      return
    end
    local script = string.format(
      'f=$(mktemp -t rex-scrollback) && rex capture -b %q --trim --unwrap > "$f" && nvim -R + -c "setlocal nomodifiable | nnoremap <buffer> q :q!<CR>" "$f"; rm -f "$f"',
      ctx.block_id
    )
    open_popup(script, nil, ctx.block_id)
  end,
})

bind_prefix("e", "scrollback_editor")


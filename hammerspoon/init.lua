-- =====================================================================
-- 1. GLOBAL SETTINGS & SHARED STATE
-- =====================================================================

---@diagnostic disable-next-line: undefined-global
local hs                           = hs

-- Define the Hyper key
local hyper                        = { "ctrl", "alt", "cmd", "shift" }

-- Disable window animations to make snapping instant
hs.window.animationDuration        = 0

-- Modern, clean styling for all hs.alert popups
hs.alert.defaultStyle.strokeColor  = { white = 1, alpha = 0 }
hs.alert.defaultStyle.fillColor    = { white = 0.1, alpha = 0.95 }
hs.alert.defaultStyle.textColor    = { white = 1, alpha = 1 }
hs.alert.defaultStyle.strokeWidth  = 0
hs.alert.defaultStyle.radius       = 16
hs.alert.defaultStyle.textSize     = 18
hs.alert.defaultStyle.textFont     = "Menlo"
hs.alert.defaultStyle.atScreenEdge = 0

-- SHARED HELP STATE
_G.helpState                       = { isVisible = false, uuid = nil }

-- Smart ESC listener (defined here, started/stopped dynamically)
_G.escapeTap                       = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  if event:getKeyCode() == 53 then -- 53 is the hardware keycode for ESC
    _G.closeHelp()
    return true                    -- Consumes the ESC key press so it doesn't leak to the OS
  end
  return false
end)

_G.closeHelp                       = function()
  if _G.helpState.isVisible then
    if _G.helpState.uuid then
      hs.alert.closeSpecific(_G.helpState.uuid)
    end
    _G.helpState.isVisible = false
    _G.helpState.uuid = nil
    _G.escapeTap:stop() -- Turn off the ESC listener immediately
  end
end

-- =====================================================================
-- 2. APPLICATION LAUNCHER
-- =====================================================================

local appShortcuts                 = {
  P = "1Password",
  B = "Brave Browser",
  G = "Gemini",
  T = "Ghostty",
  C = "Calendar",
  X = "Google Chat",
  M = "Gmail",
  N = "Obsidian",
  R = "Rider",
  S = "Spotify",
  E = "Visual Studio Code",
  Z = "Zed"
}

for key, appName in pairs(appShortcuts) do
  hs.hotkey.bind(hyper, key, function()
    -- Auto-dismiss the help cheat sheet if it's open!
    _G.closeHelp()

    local frontmostApp = hs.application.frontmostApplication()

    if frontmostApp and frontmostApp:name() == appName then
      frontmostApp:hide()
    else
      hs.application.launchOrFocus(appName)
    end
  end)
end

-- =====================================================================
-- 3. WINDOW MANAGEMENT
-- =====================================================================

local windowMode = hs.hotkey.modal.new(hyper, 'W')

local windowActions = {
  { key = 'H', desc = "Left Half",   dir = "left" },
  { key = 'L', desc = "Right Half",  dir = "right" },
  { key = 'K', desc = "Top Half",    dir = "top" },
  { key = 'J', desc = "Bottom Half", dir = "bottom" },
  { key = 'M', desc = "Maximize",    dir = "maximize" }
}

local windowHelpText = "🪟 Window Mode\n" ..
    "━━━━━━━━━━━━━━\n"

for _, action in ipairs(windowActions) do
  windowHelpText = windowHelpText .. action.key .. "  →  " .. action.desc .. "\n"
end
windowHelpText = windowHelpText .. "Esc → Cancel"

function windowMode:entered()
  -- Auto-dismiss the global cheat sheet before showing the Window one
  _G.closeHelp()
  hs.alert.closeAll()
  hs.alert.show(windowHelpText, 999999)
end

function windowMode:exited()
  hs.alert.closeAll()
end

local function moveWindow(direction)
  local win = hs.window.focusedWindow()
  if not win then return end

  local f = win:frame()
  local screen = win:screen():frame()

  if direction == "left" then
    f.x = screen.x
    f.y = screen.y
    f.w = screen.w / 2
    f.h = screen.h
  elseif direction == "right" then
    f.x = screen.x + (screen.w / 2)
    f.y = screen.y
    f.w = screen.w / 2
    f.h = screen.h
  elseif direction == "top" then
    f.x = screen.x
    f.y = screen.y
    f.w = screen.w
    f.h = screen.h / 2
  elseif direction == "bottom" then
    f.x = screen.x
    f.y = screen.y + (screen.h / 2)
    f.w = screen.w
    f.h = screen.h / 2
  elseif direction == "maximize" then
    f = screen
  end

  win:setFrame(f)
  windowMode:exit()
end

for _, action in ipairs(windowActions) do
  windowMode:bind('', string.lower(action.key), function()
    moveWindow(action.dir)
  end)
end

windowMode:bind('', 'escape', function()
  windowMode:exit()
end)

-- =====================================================================
-- 4. INSERT MODE
-- =====================================================================

local insertMode = hs.hotkey.modal.new(hyper, 'I')

local insertActions = {
  { key = 'D', desc = "Current Date (YYYY-MM-DD)",      format = "%Y-%m-%d" },
  { key = 'T', desc = "Current Time (HH:MM)",           format = "%H:%M" },
  { key = 'N', desc = "Current Date Time (YYYY-MM-DD HH:MM)", format = "%Y-%m-%d %H:%M" }
}

local insertHelpText = "📝 Insert Mode\n" ..
    "━━━━━━━━━━━━━━\n"

for _, action in ipairs(insertActions) do
  insertHelpText = insertHelpText .. action.key .. "  →  " .. action.desc .. "\n"
end
insertHelpText = insertHelpText .. "Esc → Cancel"

function insertMode:entered()
  _G.closeHelp()
  hs.alert.closeAll()
  hs.alert.show(insertHelpText, 999999)
end

function insertMode:exited()
  hs.alert.closeAll()
end

for _, action in ipairs(insertActions) do
  insertMode:bind('', string.lower(action.key), function()
    hs.eventtap.keyStrokes(os.date(action.format))
    insertMode:exit()
  end)
end

insertMode:bind('', 'escape', function()
  insertMode:exit()
end)

-- =====================================================================
-- 5. AUTO-RELOAD
-- =====================================================================

local function reloadConfig(files)
  local doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then doReload = true end
  end
  if doReload then hs.reload() end
end

hs.pathwatcher.new(hs.configdir .. "/", reloadConfig):start()
hs.alert.show("Hammerspoon Config Loaded", 1)

-- =====================================================================
-- 6. HYPER KEY CHEAT SHEET (Bound to H)
-- =====================================================================

local appHelpText = "🚀 App Shortcuts\n" ..
    "━━━━━━━━━━━━━━━━━\n"

local sortedKeys = {}
for key in pairs(appShortcuts) do table.insert(sortedKeys, key) end
table.sort(sortedKeys)

for _, key in ipairs(sortedKeys) do
  appHelpText = appHelpText .. key .. "  →  " .. appShortcuts[key] .. "\n"
end
appHelpText = appHelpText .. "A  →  [Gemini mini chat]\n"
appHelpText = appHelpText .. "D  →  [Homerow Scroll]\n"
appHelpText = appHelpText .. "F  →  [Homerow Find]\n"
appHelpText = appHelpText .. "I  →  [Insert Mode]\n"
appHelpText = appHelpText .. "W  →  [Window Mode]"

hs.hotkey.bind(hyper, 'h', function()
  if _G.helpState.isVisible then
    _G.closeHelp()
  else
    hs.alert.closeAll()
    _G.helpState.uuid = hs.alert.show(appHelpText, 999999)
    _G.helpState.isVisible = true
    _G.escapeTap:start() -- Turn on the ESC listener while the popup is visible
  end
end)

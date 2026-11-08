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

-- Registry for internal Hyper actions (populated by sections below)
local hyperBindings                = {}

-- Smart ESC listener (defined here, started/stopped dynamically)
if _G.escapeTap then _G.escapeTap:stop() end
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
-- 2. HARDWARE REMAPPING VIA HIDUTIL (Self-contained & self-healing)
-- Maps:
--   1. Caps Lock (0x700000039)        -> Left Control (0x7000000E0)
--   2. Non-US Backslash (0x700000064) -> Grave Accent / Tilde (0x700000035)
-- =====================================================================

local hidutilMapping = [[{"UserKeyMapping":[
  {"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0},
  {"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035}
]}]]

local function applyHidutilMappings()
  local cleanJson = hidutilMapping:gsub("%s+", "")
  hs.task.new("/usr/bin/hidutil", nil, { "property", "--set", cleanJson }):start()
end

-- Apply immediately on startup/reload
applyHidutilMappings()

-- Re-apply after sleep/wake or screen unlock
if _G.hidSleepWatcher then _G.hidSleepWatcher:stop() end
_G.hidSleepWatcher = hs.caffeinate.watcher.new(function(eventType)
  if eventType == hs.caffeinate.watcher.systemDidWake or
     eventType == hs.caffeinate.watcher.screensDidUnlock then
    hs.timer.doAfter(1, applyHidutilMappings)
  end
end):start()

-- Re-apply when USB/external keyboard devices are connected
if _G.hidUsbWatcher then _G.hidUsbWatcher:stop() end
_G.hidUsbWatcher = hs.usb.watcher.new(function(data)
  if data.eventType == "added" then
    hs.timer.doAfter(1, applyHidutilMappings)
  end
end):start()

-- =====================================================================
-- 3. APPLICATION LAUNCHER
-- =====================================================================

local appShortcuts                 = {
  { key = "B", mnemonic = "[B]rowser",    app = "Brave Browser" },
  { key = "C", mnemonic = "[C]alendar",   app = "Calendar" },
  { key = "E", mnemonic = "[E]ditor",     app = "Visual Studio Code" },
  { key = "G", mnemonic = "[G]emini",     app = "Gemini" },
  { key = "K", mnemonic = "[K]ubernetes", app = "Freelens" },
  { key = "M", mnemonic = "[M]ail",       app = "Gmail" },
  { key = "N", mnemonic = "[N]otes",      app = "Obsidian" },
  { key = "P", mnemonic = "[P]asswords",  app = "1Password" },
  { key = "R", mnemonic = "[R]ider",      app = "Rider" },
  { key = "S", mnemonic = "[S]potify",    app = "Spotify" },
  { key = "T", mnemonic = "[T]erminal",   app = "Ghostty" },
  { key = "V", mnemonic = "[V]ideo",      app = "Google Meet" },
  { key = "X", mnemonic = "[X]at",        app = "Google Chat" },
  { key = "Z", mnemonic = "[Z]ed",        app = "Zed" }
}

for _, item in ipairs(appShortcuts) do
  local fn = function()
    -- Auto-dismiss the help cheat sheet if it's open!
    _G.closeHelp()

    local frontmostApp = hs.application.frontmostApplication()

    if frontmostApp and frontmostApp:name() == item.app then
      frontmostApp:hide()
    else
      hs.application.launchOrFocus(item.app)
    end
  end
  hyperBindings[string.lower(item.key)] = fn
  hs.hotkey.bind(hyper, item.key, fn)
end

-- =====================================================================
-- 4. WINDOW MANAGEMENT
-- =====================================================================

local windowMode = hs.hotkey.modal.new(hyper, 'W')
local windowModeActive = false

local windowActions = {
  { key = 'H', desc = "Left Half",      dir = "left" },
  { key = 'L', desc = "Right Half",     dir = "right" },
  { key = 'K', desc = "Top Half",       dir = "top" },
  { key = 'J', desc = "Bottom Half",    dir = "bottom" },
  { key = 'M', desc = "Maximize",       dir = "maximize" },
  { key = 'C', desc = "Center (60%)",   dir = "center" }
}

local windowHelpText = "🪟 Window Mode\n" ..
    "━━━━━━━━━━━━━━\n"

for _, action in ipairs(windowActions) do
  windowHelpText = windowHelpText .. action.key .. "  →  " .. action.desc .. "\n"
end
windowHelpText = windowHelpText .. "Esc → Cancel"

function windowMode:entered()
  windowModeActive = true
  -- Auto-dismiss the global cheat sheet before showing the Window one
  _G.closeHelp()
  hs.alert.closeAll()
  hs.alert.show(windowHelpText, 999999)
end

function windowMode:exited()
  windowModeActive = false
  hs.alert.closeAll()
end

hyperBindings["w"] = function()
  if windowModeActive then windowMode:exit() else windowMode:enter() end
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
  elseif direction == "center" then
    local wRatio = 0.60
    f.w = screen.w * wRatio
    f.h = screen.h
    f.x = screen.x + (screen.w - f.w) / 2
    f.y = screen.y
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
-- 5. INSERT MODE
-- =====================================================================

local insertMode = hs.hotkey.modal.new(hyper, 'I')
local insertModeActive = false

local insertActions = {
  { key = 'D', desc = "Current Date (YYYY-MM-DD)",         format = "%Y-%m-%d" },
  { key = 'T', desc = "Current Time (HH:MM)",              format = "%H:%M" },
  { key = 'N', desc = "Current Date Time (YYYY-MM-DD HH:MM)", format = "%Y-%m-%d %H:%M" }
}

local insertHelpText = "📝 Insert Mode\n" ..
    "━━━━━━━━━━━━━━\n"

for _, action in ipairs(insertActions) do
  insertHelpText = insertHelpText .. action.key .. "  →  " .. action.desc .. "\n"
end
insertHelpText = insertHelpText .. "Esc → Cancel"

function insertMode:entered()
  insertModeActive = true
  _G.closeHelp()
  hs.alert.closeAll()
  hs.alert.show(insertHelpText, 999999)
end

function insertMode:exited()
  insertModeActive = false
  hs.alert.closeAll()
end

hyperBindings["i"] = function()
  if insertModeActive then insertMode:exit() else insertMode:enter() end
end

for _, action in ipairs(insertActions) do
  insertMode:bind('', string.lower(action.key), function()
    insertMode:exit()
    hs.eventtap.keyStrokes(os.date(action.format))
  end)
end

insertMode:bind('', 'escape', function()
  insertMode:exit()
end)

-- =====================================================================
-- 6. HYPER KEY CHEAT SHEET (Bound to H)
-- =====================================================================

local appHelpText = "🚀 App Shortcuts\n" ..
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"

for _, item in ipairs(appShortcuts) do
  appHelpText = appHelpText .. string.format("%-12s →  %s\n", item.mnemonic, item.app)
end

appHelpText = appHelpText .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
appHelpText = appHelpText .. string.format("%-12s →  %s\n", "[A]I", "Gemini Mini Chat")
appHelpText = appHelpText .. string.format("%-12s →  %s\n", "[D]own", "Homerow Scroll")
appHelpText = appHelpText .. string.format("%-12s →  %s\n", "[F]ind", "Homerow Find")
appHelpText = appHelpText .. string.format("%-12s →  %s\n", "[I]nsert", "Insert Mode")
appHelpText = appHelpText .. string.format("%-12s →  %s", "[W]indow", "Window Mode")

local function toggleHelp()
  if _G.helpState.isVisible then
    _G.closeHelp()
  else
    hs.alert.closeAll()
    _G.helpState.uuid = hs.alert.show(appHelpText, 999999)
    _G.helpState.isVisible = true
    _G.escapeTap:start() -- Turn on the ESC listener while the popup is visible
  end
end

hyperBindings["h"] = toggleHelp
hs.hotkey.bind(hyper, 'h', toggleHelp)

-- =====================================================================
-- 7. KARABINER COMPLEX MODIFICATIONS (Ctrl + ; -> Esc & Tab -> Hyper)
-- =====================================================================

local eventtap   = hs.eventtap
local eventTypes = eventtap.event.types
local keyCodes   = hs.keycodes.map

local TAB_CODE       = keyCodes["tab"] or 48
local SEMICOLON_CODE = keyCodes["semicolon"] or keyCodes[";"] or 41
local ESCAPE_CODE    = keyCodes["escape"] or 53

local tabHeldAsHyper    = false
local tabUsedWithKey    = false
local syntheticInFlight = false

local function hasAnyMainModifier(flags)
  return flags.cmd or flags.alt or flags.ctrl or flags.shift
end

if _G.karabinerTap then _G.karabinerTap:stop() end

_G.karabinerTap = eventtap.new({ eventTypes.keyDown, eventTypes.keyUp }, function(event)
  if syntheticInFlight then return false end

  local keyCode   = event:getKeyCode()
  local flags     = event:getFlags()
  local isKeyDown = (event:getType() == eventTypes.keyDown)
  local isRepeat  = (event:getProperty(eventtap.event.properties.keyboardEventAutorepeat) == 1)

  -- -------------------------------------------------------------------
  -- Rule 1: Ctrl + Semicolon -> Escape (works with Help popup & Modals!)
  -- -------------------------------------------------------------------
  if keyCode == SEMICOLON_CODE and flags.ctrl and not tabHeldAsHyper then
    if isKeyDown then
      if _G.helpState.isVisible then
        _G.closeHelp()
        return true
      elseif windowModeActive then
        windowMode:exit()
        return true
      elseif insertModeActive then
        insertMode:exit()
        return true
      end
    end
    event:setKeyCode(ESCAPE_CODE)
    event:setFlags({})
    return false
  end

  -- -------------------------------------------------------------------
  -- Rule 2: Tab -> Hyper Key (only if NO modifier was held when Tab pressed)
  -- -------------------------------------------------------------------
  if keyCode == TAB_CODE then
    if isKeyDown then
      -- If Cmd, Ctrl, Opt, or Shift is already held (e.g. Cmd+Tab, Ctrl+Tab, Shift+Tab),
      -- pass Tab through normally
      if not tabHeldAsHyper and hasAnyMainModifier(flags) then
        return false
      end

      if not tabHeldAsHyper then
        tabHeldAsHyper = true
        tabUsedWithKey = false
      end
      return true -- Swallow raw Tab keyDown
    else
      -- Tab keyUp
      if tabHeldAsHyper then
        local sendPlainTab = not tabUsedWithKey
        tabHeldAsHyper = false
        tabUsedWithKey = false

        -- Matches Karabiner's lazy: true on to_if_alone (fires Tab on release if no key was chorded)
        if sendPlainTab then
          syntheticInFlight = true
          eventtap.keyStroke({}, "tab", 0)
          hs.timer.doAfter(0.01, function() syntheticInFlight = false end)
        end
        return true
      end
      return false
    end
  end

  -- -------------------------------------------------------------------
  -- Chording a key while Tab is held as Hyper
  -- -------------------------------------------------------------------
  if tabHeldAsHyper then
    tabUsedWithKey = true
    local keyName = keyCodes[keyCode]

    if isKeyDown and not isRepeat and keyName then
      local lowerKey = string.lower(keyName)

      -- 1) If bound inside Hammerspoon (App Launcher, Window/Insert modal, Help), call directly
      if hyperBindings[lowerKey] then
        hyperBindings[lowerKey]()
        return true
      end

      -- 2) Otherwise broadcast synthetic Hyper + Key for external apps (Homerow D/F, Gemini A, etc.)
      syntheticInFlight = true
      eventtap.keyStroke(hyper, keyCode, 0)
      hs.timer.doAfter(0.01, function() syntheticInFlight = false end)
      return true
    end

    -- Swallow keyUp / repeats of chorded Hyper keys so underlying app doesn't type the raw letter
    return true
  end

  return false
end)

_G.karabinerTap:start()

-- =====================================================================
-- 8. AUTO-RELOAD & WATCHDOG
-- =====================================================================

local function reloadConfig(files)
  local doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then doReload = true end
  end
  if doReload then hs.reload() end
end

if _G.configWatcher then _G.configWatcher:stop() end
_G.configWatcher = hs.pathwatcher.new(hs.configdir .. "/", reloadConfig):start()

-- Keep eventtap alive and re-assert hidutil if macOS ever drops it
if _G.tapWatchdog then _G.tapWatchdog:stop() end
_G.tapWatchdog = hs.timer.doEvery(5, function()
  if _G.karabinerTap and not _G.karabinerTap:isEnabled() then
    _G.karabinerTap:start()
  end
end)

hs.alert.show("Hammerspoon Config Loaded", 1)

#!/usr/bin/env bash

# Close System Settings to prevent cached overrides
osascript -e 'tell application "System Settings" to quit' 2>/dev/null

echo "⚙️  Applying essential macOS settings..."

# 1. Keyboard: Fast repeat rate, short delay, and repeat keys instead of accent popup
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# 2. Input: Traditional scroll direction & disable auto-correct
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# 3. Trackpad: Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# 4. Keyboard Shortcut: Move focus to next window -> Cmd + `
kSymbolicHotKeyFocusNextWindow=27
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$kSymbolicHotKeyFocusNextWindow" \
  '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>96</integer><integer>50</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>'

# 5. Screenshots: Save to ~/Screenshots
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"

# 6. Finder: Show breadcrumb path bar & status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Reload affected processes & hotkeys
for app in "Dock" "Finder" "SystemUIServer"; do
  killall "${app}" >/dev/null 2>&1 || true
done
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true

echo "✅ Done!"

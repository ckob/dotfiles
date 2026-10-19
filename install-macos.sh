#!/bin/bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/install-common.sh"

echo "🍎 Starting macOS dotfiles installation..."

# 1. Link shared CLI dotfiles
link_common_dotfiles

# 2. Link macOS / GUI-specific dotfiles
echo "🔗 Setting up macOS and GUI dotfiles..."
safe_link "$DIR/.ideavimrc" ~/.ideavimrc
safe_link "$DIR/zed/keymap.jsonc" ~/.config/zed/keymap.json
safe_link "$DIR/zed/settings.jsonc" ~/.config/zed/settings.json
safe_link "$DIR/zed/tasks.jsonc" ~/.config/zed/tasks.json
safe_link "$DIR/zed/scripts" ~/.config/zed/scripts
safe_link "$DIR/karabiner" ~/.config/karabiner
safe_link "$DIR/ghostty" ~/.config/ghostty
safe_link "$DIR/hammerspoon" ~/.config/hammerspoon
defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"
safe_link "$DIR/obsidian/.obsidian.vimrc" ~/ObsidianNotes/.obsidian.vimrc

# 3. Apply macOS customized defaults
echo "🍎 Applying macOS defaults..."
bash "$DIR/macos/set-defaults.sh"

# 4. VSCode flavors settings
echo "⚙️  Setting up VSCode flavors..."
mkdir -p ~/Library/Application\ Support/Code/User
mkdir -p ~/Library/Application\ Support/Cursor/User
mkdir -p ~/Library/Application\ Support/Windsurf/User
mkdir -p ~/Library/Application\ Support/Antigravity/User

echo "🔧 Setting up editor configurations..."
safe_link "$DIR/vscode/settings.jsonc" ~/Library/Application\ Support/Code/User/settings.json
safe_link "$DIR/vscode/settings.jsonc" ~/Library/Application\ Support/Cursor/User/settings.json
safe_link "$DIR/vscode/settings.jsonc" ~/Library/Application\ Support/Windsurf/User/settings.json
safe_link "$DIR/vscode/settings.jsonc" ~/Library/Application\ Support/Antigravity/User/settings.json
safe_link "$DIR/vscode/keybindings.jsonc" ~/Library/Application\ Support/Code/User/keybindings.json
safe_link "$DIR/vscode/keybindings.jsonc" ~/Library/Application\ Support/Cursor/User/keybindings.json
safe_link "$DIR/vscode/keybindings.jsonc" ~/Library/Application\ Support/Windsurf/User/keybindings.json
safe_link "$DIR/vscode/keybindings.jsonc" ~/Library/Application\ Support/Antigravity/User/keybindings.json

# 5. Obsidian automated sync
if [ -f "$HOME/ObsidianNotes/sync.sh" ]; then
  chmod +x "$HOME/ObsidianNotes/sync.sh"

  echo "⏰ Setting up Obsidian automated sync..."
  SCRIPT_SYNC_TAG="obsidian-script-sync-job"
  SYNC_SCRIPT_PATH="$HOME/ObsidianNotes/sync.sh"
  SYNC_CRON_CMD="*/5 * * * * \"$SYNC_SCRIPT_PATH\" >> \"$HOME/obsidian-script-sync.log\" 2>&1 # $SCRIPT_SYNC_TAG"

  (crontab -l 2>/dev/null | grep -v "$SCRIPT_SYNC_TAG"; echo "$SYNC_CRON_CMD") | crontab -
fi

echo "✅ macOS installation complete!"

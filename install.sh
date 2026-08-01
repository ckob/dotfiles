#!/bin/bash

# Get the directory of this script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Starting dotfiles installation..."

# Function to safely and idempotently create a symlink
safe_link() {
  local source="$1"
  local target="$2"

  # Check for a real file/directory at the target and exit if found
  if [ -e "$target" ] && ! [ -L "$target" ]; then
    echo "❌ Error: A real file/directory exists at $target."
    echo "   Please remove or back it up manually."
    return 1 # Use return instead of exit to allow the script to continue
  fi

  # If the target is a symlink, remove it first.
  # The -f flag prevents errors if it doesn't exist.
  rm -f "$target"

  # Create the new symlink. We don't need ln's -f flag anymore.
  echo "🔗 Creating symlink: $target -> $source"
  ln -s "$source" "$target"
}


# Create symlinks for dotfiles
echo "🔗 Setting up dotfiles..."
safe_link "$DIR/.zshenv" ~/.zshenv
safe_link "$DIR/zsh" ~/.config/zsh
safe_link "$DIR/.editorconfig" ~/.editorconfig
safe_link "$DIR/.ideavimrc" ~/.ideavimrc
safe_link "$DIR/git" ~/.config/git
safe_link "$DIR/nvim" ~/.config/nvim
safe_link "$DIR/nvim-lazyvim" ~/.config/nvim-lazyvim
safe_link "$DIR/zed/keymap.jsonc" ~/.config/zed/keymap.json
safe_link "$DIR/zed/settings.jsonc" ~/.config/zed/settings.json
safe_link "$DIR/zed/tasks.jsonc" ~/.config/zed/tasks.json
safe_link "$DIR/zed/scripts" ~/.config/zed/scripts
safe_link "$DIR/karabiner" ~/.config/karabiner
safe_link "$DIR/ghostty" ~/.config/ghostty
safe_link "$DIR/zellij" ~/.config/zellij
safe_link "$DIR/tmux" ~/.config/tmux
safe_link "$DIR/television" ~/.config/television
safe_link "$DIR/fd" ~/.config/fd
safe_link "$DIR/lazygit" ~/.config/lazygit
safe_link "$DIR/herdr" ~/.config/herdr
safe_link "$DIR/hammerspoon" ~/.config/hammerspoon
defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"

safe_link "$DIR/obsidian/.obsidian.vimrc" ~/ObsidianNotes/.obsidian.vimrc

echo "⚙️  Setting up VSCode flavors..."

# Create necessary directories if they don't exist
mkdir -p ~/Library/Application\ Support/Code/User
mkdir -p ~/Library/Application\ Support/Cursor/User
mkdir -p ~/Library/Application\ Support/Windsurf/User
mkdir -p ~/Library/Application\ Support/Antigravity/User

# VSCode flavors settings
echo "🔧 Setting up editor configurations..."
safe_link "$DIR/vscode/settings.jsonc" ~/Library/Application\ Support/Code/User/settings.json
safe_link "$DIR/vscode/settings.jsonc" ~/Library/Application\ Support/Cursor/User/settings.json
safe_link "$DIR/vscode/settings.jsonc" ~/Library/Application\ Support/Windsurf/User/settings.json
safe_link "$DIR/vscode/settings.jsonc" ~/Library/Application\ Support/Antigravity/User/settings.json
safe_link "$DIR/vscode/keybindings.jsonc" ~/Library/Application\ Support/Code/User/keybindings.json
safe_link "$DIR/vscode/keybindings.jsonc" ~/Library/Application\ Support/Cursor/User/keybindings.json
safe_link "$DIR/vscode/keybindings.jsonc" ~/Library/Application\ Support/Windsurf/User/keybindings.json
safe_link "$DIR/vscode/keybindings.jsonc" ~/Library/Application\ Support/Antigravity/User/keybindings.json

echo "✅ Installation complete!"

#!/bin/bash

# Shared dotfiles installation logic (used by both macOS and Ubuntu headless)
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to safely and idempotently create a symlink
safe_link() {
  local source="$1"
  local target="$2"

  # Ensure the parent directory exists
  mkdir -p "$(dirname "$target")"

  # Check for a real file/directory at the target and skip if found
  if [ -e "$target" ] && ! [ -L "$target" ]; then
    echo "❌ Error: A real file/directory exists at $target."
    echo "   Please remove or back it up manually."
    return 1
  fi

  # If the target is a symlink, remove it first.
  rm -f "$target"

  # Create the new symlink.
  echo "🔗 Creating symlink: $target -> $source"
  ln -s "$source" "$target"
}

link_common_dotfiles() {
  echo "🔗 Setting up shared CLI dotfiles..."
  safe_link "$DIR/.zshenv" ~/.zshenv
  safe_link "$DIR/zsh" ~/.config/zsh
  safe_link "$DIR/.editorconfig" ~/.editorconfig
  safe_link "$DIR/git" ~/.config/git
  safe_link "$DIR/opencode/tui.jsonc" ~/.config/opencode/tui.jsonc
  safe_link "$DIR/nvim" ~/.config/nvim
  safe_link "$DIR/television" ~/.config/television
  safe_link "$DIR/fd" ~/.config/fd
  safe_link "$DIR/lazygit" ~/.config/lazygit
  safe_link "$DIR/herdr" ~/.config/herdr
}

# If executed directly (rather than sourced), run link_common_dotfiles
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  link_common_dotfiles
fi

#!/bin/bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/install-common.sh"

echo "🐧 Starting Ubuntu Headless dotfiles installation..."

# 1. Add Neovim unstable PPA (if not already added)
if ! grep -Rq "neovim-ppa/unstable" /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null; then
  echo "📦 Adding Neovim unstable PPA..."
  sudo apt-get update
  sudo apt-get install -y software-properties-common
  sudo add-apt-repository -y ppa:neovim-ppa/unstable
fi

# 2. Install core CLI packages via apt
echo "📦 Installing packages via apt-get..."
sudo apt-get update
sudo apt-get install -y \
  zsh \
  git \
  curl \
  wget \
  unzip \
  build-essential \
  jq \
  ripgrep \
  fd-find \
  fzf \
  zoxide \
  bat \
  git-delta \
  lazygit \
  gh \
  tree \
  neovim \
  python3-dev \
  python3-pip \
  python3-neovim \
  nodejs \
  npm

# 3. Symlink Ubuntu-renamed binaries to ~/.local/bin
mkdir -p "$HOME/.local/bin"
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  echo "🔗 Linking fdfind -> ~/.local/bin/fd"
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
  echo "🔗 Linking batcat -> ~/.local/bin/bat"
  ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
fi

# 4. Install Oh My Zsh (unattended) if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🐚 Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 5. Install OpenCode if not already installed
if ! command -v opencode >/dev/null 2>&1 && [ ! -x "$HOME/.opencode/bin/opencode" ]; then
  echo "🤖 Installing OpenCode..."
  curl -fsSL https://opencode.ai/v2/install | bash
fi

# 6. Install herdr if not already installed
if ! command -v herdr >/dev/null 2>&1; then
  echo "🐑 Installing herdr..."
  curl -fsSL https://herdr.dev/install.sh | sh
fi

# 7. Link shared CLI dotfiles
link_common_dotfiles

# 8. Set Zsh as default shell if not already set
if [ "$SHELL" != "$(command -v zsh)" ]; then
  echo "🐚 Setting Zsh as default shell..."
  sudo chsh -s "$(command -v zsh)" "$USER"
fi

echo "✅ Ubuntu headless installation complete!"

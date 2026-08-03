# ------------------------------------------------------------------------------
# Profiling (Keep at very top and very bottom)
# ------------------------------------------------------------------------------
# zmodload zsh/zprof # Uncomment to measure performance (1/2)

# ------------------------------------------------------------------------------
# Environment Variables & Core Setup
# ------------------------------------------------------------------------------

# Set Zsh config home
export XDG_CONFIG_HOME="$HOME/.config"

# Set locale
export LC_ALL=en_US.UTF-8

# Set default editor
export EDITOR="nvim"
export VISUAL="nvim"

# ------------------------------------------------------------------------------
# Homebrew
# ------------------------------------------------------------------------------
# This sets up Homebrew paths, MANPATH, INFOPATH
eval "$(brew shellenv)"

# ------------------------------------------------------------------------------
# Path Management
# ------------------------------------------------------------------------------
# Use typeset to create a unique path array (prevents duplicates)
typeset -U path

# Add local bin directories (higher priority)
path=("$HOME/bin" $path)

# Add language/tool bins (lower priority)
path=($path "$HOME/.dotnet/tools")
path=($path "$HOME/.cargo/bin")
path=($path "$HOME/.codeium/windsurf/bin")
path=($path "$HOME/.antigravity/antigravity/bin")
path=($path "$HOME/.local/bin/netcoredbg")
export BUN_INSTALL="$HOME/.bun"
path=($path "$BUN_INSTALL/bin")

# Added by get-aspire-cli.sh
path=("$HOME/.aspire/bin" $path)

# --- Ruby (from Homebrew) ---
if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  path=(/opt/homebrew/opt/ruby/bin $path)
  path=(`gem environment gemdir`/bin $path)
fi

export JAVA_HOME=$(/usr/libexec/java_home)
path=($path $JAVA_HOME/bin)

# Aspire config
export ASPIRE_CONTAINER_RUNTIME=podman

# Note: The 'path' array is automatically tied to the $PATH variable.
# No need for an extra `export PATH`.

# ------------------------------------------------------------------------------
# Oh My Zsh
# ------------------------------------------------------------------------------

# Path to your OMZ installation
export ZSH="$HOME/.oh-my-zsh"

# --- OMZ Configuration ---
zstyle ':omz:completion' use-cache yes
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 13

ZSH_THEME="robbyrussell"
plugins=(
    git
    wd
    nvm
    thefuck
)

# --- Completions (must be loaded *before* sourcing OMZ) ---
# Docker Desktop completions
fpath=("$HOME/.docker/completions" $fpath)

# Source machine-specific Zsh overrides & plugins (before OMZ)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# Source Oh My Zsh (This will run compinit)
source $ZSH/oh-my-zsh.sh

# --- Completions (load *after* sourcing OMZ) ---
# kubectl config
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# ------------------------------------------------------------------------------
# Tool Initialization (evals)
# ------------------------------------------------------------------------------

# fnm (faster node nvm)
eval "$(fnm env --use-on-cd --shell zsh)"

# zoxide (better cd)
eval "$(zoxide init zsh)"

# fzf (fuzzy finder)
eval "$(fzf --zsh)"

# ------------------------------------------------------------------------------
# Tool Configuration
# ------------------------------------------------------------------------------

# --- FZF Configuration ---
# https://www.josean.com/posts/7-amazing-cli-tools
export FZF_DEFAULT_OPTS="--bind='ctrl-p:up,ctrl-n:down'"

# Use fd (faster find) with fzf
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd for fzf completion
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# ------------------------------------------------------------------------------
# Key Bindings
# ------------------------------------------------------------------------------
# Make Ctrl+p and Ctrl+n search history based on what you've already typed
# (Matches the behavior of the Up/Down arrows in your current setup)
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# ------------------------------------------------------------------------------
# Aliases & Functions
# ------------------------------------------------------------------------------

# General
alias cd="z" # zoxide
alias k=kubectl
compdef __start_kubectl k # kubectl completion for 'k'

# Tools
alias lg='lazygit'
alias lazygitrider='lazygit --use-config-file $HOME/.config/lazygit/rider_config.yml'
alias surf='windsurf' # Codeium

# Neovim
alias n="nvim"
alias nk='NVIM_APPNAME="nvim-kickstart" nvim'
alias nl='NVIM_APPNAME="nvim-lazyvim" nvim'

# Opencode
alias oc='opencode'

# Lazydotnet
alias locallazydotnet='dotnet $HOME/repos/personal/lazydotnet/src/bin/Debug/net10.0/lazydotnet.dll'
# alias ld='lazydotnet'

alias agy-yolo='agy --dangerously-skip-permissions'

# ------------------------------------------------------------------------------
# Secrets & Local Config (Untracked)
# ------------------------------------------------------------------------------

# Local secrets & API tokens
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"

# Source local env
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# ------------------------------------------------------------------------------
# Commented-Out Settings
# ------------------------------------------------------------------------------

# Disabled temporarily trying DotRush with analyzers in Zed
# export ADD_DOTNET_LOCAL_ANALYZERS=true

# Zellij
# eval "$(zellij setup --generate-auto-start zsh)"
# [ "$TERM" != xterm-ghostty ] || eval "$(zellij setup --generate-auto-start bash)"

# ------------------------------------------------------------------------------
# Profiling (Keep at very top and very bottom)
# ------------------------------------------------------------------------------
# zprof # Uncomment to measure performance (2/2)
# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

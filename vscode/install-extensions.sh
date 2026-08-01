#!/bin/bash

# Extensions categorized by usage
COMMON_EXTENSIONS=(
  "aktyn.git-changelists-manager"
  "asvetliakov.vscode-neovim"
  "CucumberOpen.cucumber-official"
  "EdwinSulaiman.jetbrains-rider-dark-theme"
  "ms-azuretools.vscode-docker"
  "sonarsource.sonarlint-vscode"
  "yy0931.go-to-next-error"
  "TomPollak.lazygit-vscode"
)

CURSOR_ONLY=(
  "nromanov.dotrush"
)

WINDSURF_ONLY=(
  "nromanov.dotrush"
)

VSCODE_ONLY=(
  "github.copilot"
  "github.copilot-chat"
  "ms-vscode-remote.remote-containers"
  "ms-dotnettools.csdevkit"
  "ms-dotnettools.csharp"
  "ms-dotnettools.vscode-dotnet-runtime"
)

# Install common extensions if any exist
if [ ${#COMMON_EXTENSIONS[@]} -gt 0 ]; then
  echo "📦 Installing common extensions..."
  for ext in "${COMMON_EXTENSIONS[@]}"; do
    echo "Installing in both: $ext"
    code --install-extension "$ext"
    cursor --install-extension "$ext"
    windsurf --install-extension "$ext"
  done
fi

if [ ${#CURSOR_ONLY[@]} -gt 0 ]; then
  echo "📦 Installing Cursor-only extensions..."
  for ext in "${CURSOR_ONLY[@]}"; do
    echo "Installing in Cursor: $ext"
    cursor --install-extension "$ext"
  done
fi

if [ ${#VSCODE_ONLY[@]} -gt 0 ]; then
  echo "📦 Installing VSCode-only extensions..."
  for ext in "${VSCODE_ONLY[@]}"; do
    echo "Installing in VSCode: $ext"
    code --install-extension "$ext"
  done
fi

if [ ${#WINDSURF_ONLY[@]} -gt 0 ]; then
  echo "📦 Installing Windsurf-only extensions..."
  for ext in "${WINDSURF_ONLY[@]}"; do
    echo "Installing in Windsurf: $ext"
    windsurf --install-extension "$ext"
  done
fi

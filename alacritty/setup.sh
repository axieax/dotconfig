#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

# DEPENDENCIES: fontconfig
if ! check_dependency fontconfig; then
  if is_linux; then
    sudo pacman -S fontconfig
  elif is_mac; then
    brew install fontconfig
  else
    echo "Failed to install dependency: fontconfig"
  fi
fi

# Install JetBrains Mono font
action="install JetBrains Mono font"
if ! fc-list -q "JetBrainsMono" && confirm "$action"; then
  if is_linux; then
    curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh | bash
  elif is_mac; then
    brew tap homebrew/cask-fonts
    brew install --cask font-jetbrains-mono
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

# Install Meslo LG font

# Install Hack font

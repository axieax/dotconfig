#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="install alacritty"
if ! check_dependency alacritty && confirm "$action"; then
  if is_linux; then
    sudo pacman -S alacritty
  elif is_mac; then
    brew install --cask alacritty
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install JetBrains Mono font"
if confirm "$action"; then
  if is_linux; then
    yay -S ttf-jetbrains-mono-nerd
  elif is_mac; then
    brew tap homebrew/cask-fonts
    brew install --cask font-jetbrains-mono-nerd-font
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="link config"
if confirm "$action"; then
  link_config $HOME/dotconfig/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml
fi

action="set up tabs"
if is_mac && confirm "$action"; then
  defaults write org.alacritty AppleWindowTabbingMode -string always
fi

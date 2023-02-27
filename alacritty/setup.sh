#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="install alacritty"
if ! check_dependency alacritty && confirm "$action"; then
  if is_linux; then
    sudo pacman -S alacritty
  elif is_mac; then
    brew install alacritty
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install JetBrains Mono font"
if confirm "$action"; then
  if is_linux; then
    yay -S nerd-fonts-jetbrains-mono
  elif is_mac; then
    brew tap homebrew/cask-fonts
    brew install --cask font-jetbrains-mono-nerd-font
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

# Install Meslo LG font
# Install Hack font

action="link config"
if confirm "$action"; then
  if is_linux; then
    link_config $HOME/dotconfig/alacritty/alacritty-linux.yml $HOME/.config/alacritty/alacritty.yml
  elif is_mac; then
    link_config $HOME/dotconfig/alacritty/alacritty-mac.yml $HOME/.config/alacritty/alacritty.yml
  else
    echo "invalid OSTYPE $OSTYPE for alacritty setup"
  fi
fi

action="install neofetch"
if ! check_dependency neofetch && confirm "$action"; then
  if is_linux; then
    sudo pacman -S neofetch
  elif is_mac; then
    brew install neofetch
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

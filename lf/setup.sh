#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="install lf"
if ! check_dependency "lf" && confirm "$action"; then
  if is_linux; then
    sudo pacman -S lf
  elif is_mac; then
    brew install lf
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="link config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/lf/lfrc" "$HOME/.config/lf/lfrc"
fi

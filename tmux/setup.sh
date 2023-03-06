#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="install tmux"
if ! check_dependency "tmux" && confirm "$action"; then
  if is_linux; then
    sudo pacman -S tmux
  elif is_mac; then
    brew install tmux
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="link config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/tmux" "$HOME/.config/tmux"
fi

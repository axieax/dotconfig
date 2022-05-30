#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="install zscroll"
if is_linux && ! check_dependency zscroll && confirm "$action"; then
  yay -S zscroll
fi

action="install font awesome 5"
if is_linux && confirm "$action"; then
  # sudo pacman -S awesome-terminal-fonts
  yay -S ttf-font-awesome-5
  yay -S nerd-fonts-meslo
fi

action="link config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/polybar" "$HOME/.config/polybar"
fi

#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="install zscroll"
if is_linux && ! check_dependency zscroll && confirm "$action"; then
  yay -S zscroll
fi

action="link config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/polybar" "$HOME/.config/polybar"
fi

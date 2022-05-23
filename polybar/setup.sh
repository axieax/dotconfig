#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="install zscroll"
if is_linux && ! check_dependency zscroll && confirm "$action"; then
  yay -S zscroll
fi

link_config "$HOME/dotconfig/polybar" "$HOME/.config/polybar"

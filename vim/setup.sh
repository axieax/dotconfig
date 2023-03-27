#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="link vim config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/vim/.vimrc" "$HOME/.vimrc"
fi

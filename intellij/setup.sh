#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="link IdeaVim config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/intellij/.ideavimrc" "$HOME/.ideavimrc"
fi

action="disable MacOS press and hold"
if confirm "$action"; then
  defaults write -g ApplePressAndHoldEnabled -bool false
fi

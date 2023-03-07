#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="install lazygit"
if ! check_dependency lazygit && confirm "$action"; then
  if is_linux; then
    sudo pacman -S lazygit
  elif is_mac; then
    brew install lazygit
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install commitizen"
if ! check_dependency commitizen && confirm "$action"; then
  npm install -g commitizen cz-conventional-changelog
fi

action="link commitizen config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/lazygit/.czrc" "$HOME/.czrc"
fi

action="link lazygit config"
if confirm "$action"; then
  if is_linux; then
    link_config "$HOME/dotconfig/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
  elif is_mac; then
    link_config "$HOME/dotconfig/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

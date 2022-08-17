#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="install lazygit"
if ! check_dependency lazygit; then
  go install github.com/jesseduffield/lazygit@latest
fi

action="install commitizen"
if ! check_dependency commitizen; then
  yarn global add commitizen cz-conventional-changelog
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

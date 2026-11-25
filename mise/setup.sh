#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

mise_bin() {
  command -v mise || echo "$HOME/.local/bin/mise"
}

action="install mise"
if [ ! -x "$(mise_bin)" ] && confirm "$action"; then
  if is_mac; then
    brew install mise
  elif is_linux; then
    # The standalone binary in ~/.local/bin, so `mise self-update` works.
    curl -fsSL https://mise.run | sh
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="link mise config"
if confirm "$action"; then
  # Named global.toml, not config.toml: mise would also read mise/config.toml as ~/dotconfig's
  # own project config.
  link_config "$HOME/dotconfig/mise/global.toml" "$HOME/.config/mise/config.toml"
fi

action="install mise tools"
if confirm "$action"; then
  "$(mise_bin)" install
fi

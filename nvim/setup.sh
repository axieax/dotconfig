#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

# Install Neovim
action="install Neovim"
if ! check_dependency "nvim" && confirm "$action"; then
  if is_linux; then
    sudo pacman -S neovim
  elif is_mac; then
    brew install neovim
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install Neovim Python support"
if ! $OS_PYTHON -c "import neovim" 2> /dev/null && confirm "$action"; then
  $OS_PIP install pynvim
fi

# Setup Java - JRE, JDK, Java (sudo pacman -S jre-openjdk)

# Formatters
# TODO: replace local installations with nvim wrapper plugins

# Null-ls Sources
action="install google-java-format formatter"
if ! check_dependency "google-java-format" && confirm "$action"; then
  if is_linux; then
    yay -S google-java-format
  elif is_mac; then
    brew install google-java-format
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install prettierd formatter"
if ! check_dependency "prettierd" && confirm "$action"; then
  yarn global add @fsouza/prettierd
fi

action="install prettier extensions"
if confirm "$action"; then
  # yarn global add prettier-plugin-apex
  # yarn global add prettier-plugin-elm
  # yarn global add prettier-plugin-java
  # yarn global add prettier-plugin-solidity
  yarn global add prettier-plugin-toml
  # yarn global add prettier-plugin-svelte
  # yarn global add prettier-plugin-kotlin
  yarn global add prettier-plugin-sh
fi

action="install cppcheck diagnostics"
if ! check_dependency "cppcheck" && confirm "$action"; then
  if is_linux; then
    sudo pacman -S cppcheck
  elif is_mac; then
    brew install cppcheck
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

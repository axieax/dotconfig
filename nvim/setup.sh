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
# TODO: replace local installations with mason

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

# TEMP: https://github.com/williamboman/mason.nvim/issues/392
action="install prettier extensions"
if confirm "$action"; then
  cd "$HOME/.local/share/nvim/mason/packages/prettierd/node_modules/@fsouza/prettierd" && npm install prettier-plugin-sh prettier-plugin-toml
  # yarn global add prettier-plugin-apex
  # yarn global add prettier-plugin-elm
  # yarn global add prettier-plugin-java
  # yarn global add prettier-plugin-solidity
  # yarn global add prettier-plugin-toml
  # yarn global add prettier-plugin-svelte
  # yarn global add prettier-plugin-kotlin
  # yarn global add prettier-plugin-sh
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

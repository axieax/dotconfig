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

# Setup Java
action="setup Java for Neovim"
if confirm "$action"; then
  # JRE, JDK, Java (sudo pacman -S jre-openjdk)
  mkdir -p "$HOME/java"
  cd "$HOME/java"

  git clone https://github.com/microsoft/java-debug
  cd java-debug
  ./mvnw clean install
  cd ..

  git clone https://github.com/microsoft/vscode-java-test
  cd vscode-java-test
  yarn install
  yarn run build-plugin
  cd ..
fi

# Formatters
# TODO: replace local installations with nvim wrapper plugins

# Null-ls Sources
action="install Stylua formatter"
if ! check_dependency "stylua" && confirm "$action"; then
  if is_linux; then
    sudo pacman -S stylua
  elif is_mac; then
    brew install stylua
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install Black formatter"
if ! check_dependency "black" && confirm "$action"; then
  $OS_PIP install black
fi

action="install isort formatter"
if ! check_dependency "isort" && confirm "$action"; then
  $OS_PIP install isort
fi

action="install prettierd formatter"
if ! check_dependency "prettierd" && confirm "$action"; then
  yarn global add @fsouza/prettierd
fi

action="install prettier extensions"
if confirm "$action"; then
  # yarn global add prettier-plugin-apex
  # yarn global add prettier-plugin-elm
  yarn global add prettier-plugin-java
  # yarn global add prettier-plugin-solidity
  yarn global add prettier-plugin-toml
  # yarn global add prettier-plugin-svelte
  # yarn global add prettier-plugin-kotlin
  yarn global add prettier-plugin-sh
fi

action="install Pylint diagnostics"
if ! check_dependency "pylint" && confirm "$action"; then
  $OS_PIP install pylint
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

action="install shellcheck diagnostics"
if ! check_dependency "shellcheck" && confirm "$action"; then
  if is_linux; then
    sudo pacman -S shellcheck
  elif is_mac; then
    brew install shellcheck
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install editorconfig diagnostics"
if ! check_dependency "editorconfig" && confirm "$action"; then
  $OS_PIP install editorconfig-checker
fi

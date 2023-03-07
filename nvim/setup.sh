#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

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

# TEMP: https://github.com/williamboman/mason.nvim/issues/392
action="install prettier extensions"
if confirm "$action"; then
  cd "$HOME/.local/share/nvim/mason/packages/prettierd/node_modules/@fsouza/prettierd" && npm install prettier-plugin-sh prettier-plugin-toml
fi

action="install ripgrep"
if ! check_dependency rg && confirm "$action"; then
  if is_linux; then
    sudo pacman -S ripgrep
  elif is_mac; then
    brew install ripgrep
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="link nvim config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/nvim" "$HOME/.config/nvim"
fi

action="link stylua config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/stylua.toml" "$HOME/.config/stylua.toml"
fi

action="link selene config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/selene.toml" "$HOME/.config/selene.toml"
  link_config "$HOME/dotconfig/vim.toml" "$HOME/.config/vim.toml"
fi

action="install sqlite for neoclip persistence"
if ! check_dependency sqlite3 && confirm "$action"; then
  if is_linux; then
    sudo pacman -S sqlite
  elif is_mac; then
    # NOTE: required to install for Mac even if built-in
    brew install sqlite
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

#!/usr/bin/env bash
# Python provider and prettierd plugins for Neovim.
source "${DOTCONFIG:-$HOME/dotconfig}/lib/dot.sh"

if dot_have python3 && ! python3 -c "import pynvim" 2>/dev/null; then
  dot_log "install pynvim"
  dot_run python3 -m pip install --quiet pynvim
fi

# https://github.com/williamboman/mason.nvim/issues/392: prettierd needs its plugins beside it.
prettierd="$HOME/.local/share/nvim/mason/packages/prettierd/node_modules/@fsouza/prettierd"
if [[ -d $prettierd && ! -d $prettierd/node_modules/prettier-plugin-toml ]]; then
  dot_log "install prettierd plugins"
  dot_run npm --prefix "$prettierd" install --silent prettier-plugin-sh prettier-plugin-toml
fi

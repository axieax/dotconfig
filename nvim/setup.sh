#!/usr/bin/env bash
# Python provider for Neovim.
source "${DOTCONFIG:-$HOME/dotconfig}/lib/dot.sh"

if dot_have python3 && ! python3 -c "import pynvim" 2>/dev/null; then
  dot_log "install pynvim"
  dot_run python3 -m pip install --quiet pynvim
fi


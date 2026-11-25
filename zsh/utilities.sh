#!/bin/zsh
# Helpers for the zsh config.

function pathadd() {
  if [[ -d "$1" ]]; then
    export PATH="$1${PATH:+":${PATH}"}"
  fi
}

function sauce() {
  if [[ -f "$1" ]]; then
    source "$1"
  fi
}

# mac or linux, naming zsh/os/<name>.zsh
function dot_os_name() {
  case "$OSTYPE" in
    darwin*) print mac ;;
    linux*) print linux ;;
  esac
}

# Installers append PATH entries to the files loaded after the repo's; move mise's shims back to
# the front so a directory's pinned tool still wins.
function dot_shims_first() {
  local shims="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims"
  [[ -d "$shims" ]] && path=("$shims" ${path:#$shims})
}

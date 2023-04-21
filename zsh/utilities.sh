#!/bin/bash

function pathadd() {
  if [[ -d "$1" ]]; then
    export PATH="$1${PATH:+":${PATH}"}"
  fi
}

function sauce() {
  [[ -f "$1" ]] && source "$1"
}

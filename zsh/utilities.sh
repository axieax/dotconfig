#!/bin/bash

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

#!/usr/bin/env bash
# T3 Code: the t3 command where no desktop app provides it, via T3's own installer
# (https://github.com/pingdotgg/t3code/blob/main/docs/user/install.md). Set T3CODE_CHANNEL=nightly
# or T3CODE_VERSION=<x> in the environment to choose what it installs.
source "${DOTCONFIG:-$HOME/dotconfig}/lib/dot.sh"

if ! dot_have t3 && [[ ! -x $HOME/.t3/bin/t3 && ! -x $HOME/.local/bin/t3 ]]; then
  dot_log "install the t3 command"
  dot_run sh -c "curl -fsSL https://t3.codes/install.sh | sh"
fi

# The background service and remote access need a sign-in and a choice of access routes, so they
# stay a step you take once: `t3 up`.
if [[ $(dot_os) == linux ]] && ! systemctl --user cat t3code.service >/dev/null 2>&1; then
  dot_warn "no T3 Code background service here; run \`t3 up\` once to set it up"
fi

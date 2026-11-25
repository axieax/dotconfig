#!/usr/bin/env bash
# Every machine: T3 Code and the agent CLIs it drives, each through its own recommended installer.
# All of them update themselves, so this only installs what is missing. See ai/README.md.
source "${DOTCONFIG:-$HOME/dotconfig}/lib/dot.sh"

# T3 Code. On a Mac the desktop app writes the t3 command to ~/.t3/bin; elsewhere (or with no app)
# T3's installer puts it in ~/.local/bin. T3CODE_CHANNEL=nightly or T3CODE_VERSION=<x> choose what
# it installs. https://github.com/pingdotgg/t3code/blob/main/docs/user/install.md
if [[ $(dot_os) == mac && ! -d "/Applications/T3 Code (Beta).app" ]]; then
  dot_warn "T3 Code desktop app not installed; download it from https://t3.codes"
fi
if ! dot_have t3 && [[ ! -x $HOME/.t3/bin/t3 && ! -x $HOME/.local/bin/t3 ]]; then
  dot_log "install the t3 command"
  dot_run sh -c "curl -fsSL https://t3.codes/install.sh | sh"
fi

# Claude Code: the native installer. https://code.claude.com/docs/en/setup
if ! dot_have claude; then
  dot_log "install Claude Code"
  dot_run bash -c "curl -fsSL https://claude.ai/install.sh | bash"
fi

# Codex CLI: the standalone installer. https://github.com/openai/codex
if ! dot_have codex; then
  dot_log "install Codex"
  dot_run sh -c "curl -fsSL https://chatgpt.com/codex/install.sh | sh"
fi

# oh-my-zsh and its plugins; zsh/setup.sh installs them.
export ZSH="$HOME/.oh-my-zsh"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13

ENABLE_CORRECTION="true"

plugins=(
  git
  zoxide
  npm
  bazel
  terraform
  starship

  # notify # NOTE: does not disappear
  auto-notify
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting # NOTE: this has to be the last plugin
  # fast-syntax-highlighting # alternative with richer colours: use instead of zsh-syntax-highlighting, never both
)
fpath+="$ZSH/custom/plugins/zsh-completions/src"

sauce "$ZSH/oh-my-zsh.sh"

AUTO_NOTIFY_IGNORE+=(
  "cd"
  "lazygit"
  "lf"
)

# Completions need compinit, which oh-my-zsh has run by now.
(( $+commands[omp] )) && eval "$(omp completions zsh)"

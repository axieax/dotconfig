# Completions that tools generate themselves, cached and on fpath before oh-my-zsh runs compinit:
# generating t3's takes about half a second. Refreshed weekly, or when T3 installs a new version.
() {
  local dir="$XDG_CACHE_HOME/zsh/completions"
  mkdir -p "$dir"
  fpath=("$dir" $fpath)
  (( $+commands[t3] )) || return 0
  local versions="${T3CODE_HOME:-$HOME/.t3}/runtime/versions"
  local stale=("$dir"/_t3(N.mh+168))
  if [[ ! -s $dir/_t3 || $versions -nt $dir/_t3 || -n $stale ]]; then
    t3 --completions zsh >| "$dir/_t3" 2>/dev/null
  fi
}

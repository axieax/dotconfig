function qr() { curl qrcode.show/$1 }

function gch() { git checkout "${1:-$(git branch --all | fzf | awk '{print $1}')}" }
function ggf() { git fetch origin "$1" }
function ggr() { git reset --soft "${1:-$(git log --oneline -100 | fzf | awk '{print $1}')}" }
function ggR() { git reset --hard "${1:-$(git log --oneline -100 | fzf | awk '{print $1}')}" }
function ggN() {
  local branch="${1:-$(git branch --show-current)}";
  git fetch origin "$branch" && git reset --hard "origin/$branch"
}

# lf with cd behaviour
function lf() {
  LF_DIR="/tmp/lf-last-dir"
  [ -f "$LF_DIR" ] && rm -f "$LF_DIR"
  command lf "$@"
  if [ -f "$LF_DIR" ]; then
    DIR="$(cat "$LF_DIR")"
    if [ -d "$DIR" ] && [ "$DIR" != "$(pwd)" ]; then
      echo "Changing directory to $DIR"
      cd "$DIR"
    fi
  fi
}

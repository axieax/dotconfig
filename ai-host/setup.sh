#!/usr/bin/env bash
# An environment other machines use: T3 Code's background service and remote access, plus
# CLIProxyAPI with cpa-reset-router ranking its accounts. Enable per machine with "+ai-host" in
# ~/.config/dotconfig/modules. Accounts, keys and access choices stay on the machine; see
# ai/README.md for the one-time steps.
source "${DOTCONFIG:-$HOME/dotconfig}/lib/dot.sh"

# T3 Code: `t3 up` installs the background service and chooses how other devices reach it (T3
# Connect, LAN/tailnet with a pairing code). It needs a sign-in, so it stays a one-time step.
if dot_have t3 && ! t3 service status 2>/dev/null | grep -qE 'Status: installed'; then
  dot_warn "T3 Code background service not set up; run \`t3 up\` once"
fi

if [[ $(dot_os) != linux ]]; then
  dot_log "CLIProxyAPI host setup here is Linux-only (systemd); skipped"
  exit 0
fi

# CLIProxyAPI's config holds keys and the account login files sit beside it, so it starts from
# the package's example on the machine, never from the repo.
cpa_config="$HOME/.cli-proxy-api/config.yaml"
example=/usr/share/doc/cli-proxy-api-bin/config.example.yaml
if [[ ! -f $cpa_config && -f $example ]]; then
  dot_log "create ${cpa_config/#$HOME/~} from the package example"
  dot_run install -D -m 600 "$example" "$cpa_config"
  dot_warn "edit ${cpa_config/#$HOME/~}, then add accounts: cli-proxy-api --config ${cpa_config/#$HOME/~} -claude-login (or -codex-login)"
fi

# cpa-reset-router (a private repo): clone or update, build with mise's Go, install what changed.
src="${XDG_DATA_HOME:-$HOME/.local/share}/dotconfig/src/cpa-reset-router"
if [[ -d $src/.git ]]; then
  dot_run git -C "$src" pull --quiet --ff-only
elif dot_have gh && gh auth status >/dev/null 2>&1; then
  dot_log "clone cpa-reset-router"
  dot_run mkdir -p "$(dirname "$src")"
  dot_run gh repo clone axieax/cpa-reset-router "$src" -- --quiet
else
  dot_warn "sign in with \`gh auth login\` to fetch cpa-reset-router (a private repo); skipped"
  exit 0
fi
if [[ $DOT_DRY_RUN == 1 && ! -d $src ]]; then
  exit 0
fi

changed=0
# install_if_changed <mode> <source> <destination>
install_if_changed() {
  if ! cmp -s "$2" "$3"; then
    dot_log "install ${3/#$HOME/~}"
    dot_run install -D -m "$1" "$2" "$3"
    changed=1
  fi
}

build=$(mktemp -d)
trap 'rm -rf "$build"' EXIT
if ! (cd "$src" && go build -o "$build/reset-router" ./cmd/reset-router); then
  dot_warn "cpa-reset-router failed to build"
  exit 1
fi
install_if_changed 755 "$build/reset-router" "$HOME/.local/bin/reset-router"
units="$HOME/.config/systemd/user"
install_if_changed 755 "$src/deploy/systemd/cpa-update.sh" "$HOME/.local/bin/cpa-update"
for unit in cpa-update.service cpa-update.timer reset-router.service; do
  install_if_changed 644 "$src/deploy/systemd/$unit" "$units/$unit"
done
install_if_changed 644 "$src/deploy/systemd/cli-proxy-api.override.conf" \
  "$units/cli-proxy-api.service.d/90-upstream-latest.conf"

# The router's own management key, generated here and never printed.
keys="$HOME/.config/cpa-reset-router"
if [[ ! -s $keys/management-key ]]; then
  dot_log "generate the router's management key"
  if [[ $DOT_DRY_RUN != 1 ]]; then
    install -d -m 700 "$keys"
    (
      umask 077
      k=$(head -c 32 /dev/urandom | base64 | tr -d '=+/\n')
      echo "$k" >"$keys/management-key"
      echo "MANAGEMENT_PASSWORD=$k" >"$keys/cpa.env"
    )
    changed=1
  fi
fi

[[ $changed == 1 ]] && dot_run systemctl --user daemon-reload
[[ -e $HOME/.local/lib/cli-proxy-api/current ]] || dot_run "$HOME/.local/bin/cpa-update" --force
for unit in cli-proxy-api.service reset-router.service cpa-update.timer; do
  systemctl --user is-enabled --quiet "$unit" 2>/dev/null || dot_run systemctl --user enable --now "$unit"
done
if [[ $changed == 1 ]] && systemctl --user is-active --quiet reset-router.service; then
  dot_run systemctl --user restart reset-router.service
fi
exit 0

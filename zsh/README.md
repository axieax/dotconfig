# zsh

zsh reads its startup files from `$ZDOTDIR`. Here that is `~/.config/zsh`, a directory on the
machine, not in the repo, so installers that append to `$ZDOTDIR/.zshrc` never edit tracked files
and history never lands in the repo (XDG layout, per the
[ArchWiki](https://wiki.archlinux.org/title/XDG_Base_Directory)).

## Load order

| zsh reads | Which shells | What it holds |
| --- | --- | --- |
| `~/.zshenv` → `zsh/.zshenv` | every shell | XDG directories, `DOTCONFIG`, `ZDOTDIR` only |
| `~/.config/zsh/.zprofile` → `zsh/zprofile` | login shells | `PATH`, Homebrew, mise shims, `secrets.zsh` |
| `~/.config/zsh/.zshrc` → `zsh/zshrc` | interactive shells | `rc.d/*.zsh` in name order, then `os/mac.zsh` or `os/linux.zsh`, then `~/.zshrc` |
| `~/.config/zsh/.zlogin` → `zsh/zlogin` | login shells, last | mise's shims back to the front of `PATH` |

`PATH` lives in `.zprofile`, not `.zshenv`, because macOS's `/etc/zprofile` (`path_helper`) would
reorder it. Each `~/.config/zsh` file is a stub that loads the repo file and then whatever follows
it; `zsh/setup.sh` copies the stubs from `stub/` once and never overwrites them.

## Where a change goes

| Change | File |
| --- | --- |
| For every machine | the matching file in `rc.d/` (or a new `NN-name.zsh`) |
| For every Mac, or every Linux box | `os/mac.zsh`, `os/linux.zsh` |
| For this machine only | below the `source` line in `~/.config/zsh/.zshrc` (or `.zprofile` for `PATH`/env) |
| A secret | `~/.config/zsh/secrets.zsh` (mode 600) |

Installers that ignore `ZDOTDIR` (LM Studio, gcloud, Antigravity) append to `~/.zshrc`, which
`zshrc` still sources last. History is in `~/.local/state/zsh/history` and completion caches in
`~/.cache/zsh`.

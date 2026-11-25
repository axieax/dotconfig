# dotconfig

My dotfiles for macOS (Homebrew) and Arch Linux (pacman, AUR, xmonad).

## Set up a machine

```sh
git clone https://github.com/axieax/dotconfig ~/dotconfig
~/dotconfig/bootstrap.sh --dry-run   # see what it would change
~/dotconfig/bootstrap.sh             # then do it; safe to re-run any time
```

`bootstrap.sh --help` lists the options: `--only=<steps>` runs some steps (prereqs, packages, mise,
links, hooks), naming modules runs only those, and `--list` shows the modules enabled here.

## How it is organised

Each top-level directory is a **module**: an app's config plus everything needed to set it up.
`modules` lists them in order, with the OS each applies to. A module may contain:

| File | What bootstrap.sh does with it |
| --- | --- |
| `packages` | Installs `brew:` and `cask:` lines on a Mac (Homebrew), `pacman:` and `aur:` lines on Arch. |
| `mise.toml` | Links it to `~/.config/mise/conf.d/<module>.toml`, then `mise install`. |
| `links` | Links each `source \| destination [\| os [\| root-copy]]` line. A correct link is left alone; anything else is backed up first. |
| `setup.sh` | Runs it last, for steps the files above cannot express. It must be safe to re-run. |

What owns what:

- **mise** installs runtimes and portable CLI tools (`mise/global.toml`, plus module `mise.toml`
  files). A project's own `mise.toml` pins its versions over these.
- **Homebrew / pacman** own system-level packages: shells, terminals, fonts, desktop apps.
- **rustup** and **ghcup** own Rust and Haskell toolchains, as those languages recommend.

## Machine-local settings

Nothing machine-specific is committed. Each machine keeps it in files outside the repo:

| File | For |
| --- | --- |
| `~/.config/zsh/.zprofile`, `.zshrc`, `.zlogin` | This machine's shell lines; installers append here too. See [zsh/README.md](zsh/README.md). |
| `~/.config/zsh/secrets.zsh` | API tokens and other secrets, mode 600. |
| `~/.config/dotconfig/modules` | `+name` adds a module, `-name` skips one: `+ai-host` makes a machine an environment others use ([ai/README.md](ai/README.md)), `-sddm` suits a headless box. |
| `~/.config/dotconfig/hooks/*.sh` | Extra setup only this machine needs; run after the module hooks. |

## Notes

- TODO: consider Nix (Home Manager) if this outgrows bootstrap.sh.
- OBS: install OBS and `v4l2loopback-dkms` for virtual camera support (Linux).
- TODO: migrate from X11 to Wayland (needs a new graphics card): Hyprland; Dunst, Mako or Swaync.

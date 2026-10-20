# Dotfiles

Personal configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level folder is a _package_ that mirrors the structure of `$HOME`.

```
sway/.config/sway/...   →   ~/.config/sway/...
```

## Usage

```sh
git clone <repo> ~/dotfiles && cd ~/dotfiles
./install.sh            # all packages
./install.sh sway nvim  # only some
./install.sh -D foot    # uninstall
./install.sh -f         # overwrite existing files (backed up to ~/.dotfiles-backup/<date>)
./install.sh -u         # git pull + re-stow (picks up added/removed files)
```

Equivalent to `stow -R -t ~ <package>`. Without `-f`, if a real file already exists at the target, stow aborts. Edits to existing files apply immediately (they are symlinks); `-u` is for new or deleted files.

## Migrating the system (packages, repos, flatpak)

`migrate.sh` saves the system state to `.migration/` so it can be restored on another Debian install.

```sh
./migrate.sh export      # old system: manual apt packages, holds, /etc/apt repos+keys+pinning, flatpak remotes+apps
git add .migration && git commit -m "Update system snapshot"

./migrate.sh import -n   # new system: dry run, shows what would happen
./migrate.sh import      # restores repos/keys, apt update, installs packages, adds flatpak remotes and apps
```

- Only manually installed packages are saved (`apt-mark showmanual`); dependencies are resolved by apt.
- Packages missing on the new system are skipped and listed in `.migration/apt/missing.txt`.
- If the Debian release differs, the official Debian sources are not copied; only third-party repos and keys are.
- Flatpak is handled per scope (system and user). Existing files in `/etc/apt` are never overwritten.
- Review `.migration/apt/etc/` before committing if the repo is public.

## Packages

| Package                                              | Contents                                                                |
| ---------------------------------------------------- | ----------------------------------------------------------------------- |
| `sway`                                               | sway, bar, dashboard, cheatsheet, scripts                               |
| `foot` `mako` `wofi` `wofi-pass` `swaylock` `kanshi` | terminal, notifications, launcher, lock screen, display profiles        |
| `nvim`                                               | Neovim 0.12 (`vim.pack`), see `nvim/.config/nvim/NOTES.md`              |
| `zsh`                                                | `.zshrc` and `.aliases` (secrets go in `~/.zshrc.local`, not versioned) |
| `tmux`                                               | `.tmux.conf`                                                            |
| `zathura` `timewarrior`                              | utilities                                                               |
| `thunar`                                             | file manager                                                            |
| `xdg-desktop-portal` `wireplumber` `wiremix`         | portals and audio                                                       |
| `colors`                                             | shared palette and the script that applies it                           |

## After cloning

- Create `~/.zshrc.local` with the secrets.
- `sway/assets/bg` points to a `desktop-base` wallpaper (Debian).

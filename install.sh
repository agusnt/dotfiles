#!/usr/bin/env bash
# Install the dotfiles with GNU Stow.
# Usage: ./install.sh [-f] [-u] [-D] [package...]   (no packages: all)
#   -f, --force      overwrite existing files at the target (backed up first)
#   -u, --update     pull the repo (if it is a git checkout) and re-stow, so new
#                    or removed files in the local config are reflected in $HOME
#   -D, --delete     uninstall
set -euo pipefail
cd "$(dirname "$0")"

command -v stow >/dev/null || { echo "Install GNU stow first" >&2; exit 1; }
[[ -f .stowrc ]] || { echo ".stowrc missing in $PWD" >&2; exit 1; }

force=0 update=0 delete=0
while (($#)); do
  case $1 in
    -f|--force) force=1 ;;
    -u|--update) update=1 ;;
    -D|--delete) delete=1 ;;
    -h|--help) sed -n '2,7p' "$0" | sed 's/^# \?//'; exit 0 ;;
    --) shift; break ;;
    -*) echo "Unknown option: $1" >&2; exit 1 ;;
    *) break ;;
  esac
  shift
done

if (($#)); then pkgs=("$@"); else
  mapfile -t pkgs < <(find . -mindepth 1 -maxdepth 1 -type d -not -name '.*' -printf '%f\n' | sort)
fi

mkdir -p "$HOME/.config"
stow_args=(--verbose=1)   # target comes from .stowrc (read from this directory)

# Stow refuses packages that contain absolute symlinks (e.g. sway/assets/bg),
# so skip them in stow and link them by hand afterwards.
abs_links=()   # "pkg<TAB>relative path inside pkg"
for pkg in "${pkgs[@]}"; do
  while IFS= read -r -d '' f; do
    [[ $(readlink "$f") == /* ]] || continue
    rel=${f#"./$pkg/"}
    abs_links+=("$pkg"$'\t'"$rel")
    stow_args+=(--ignore="^$(printf '%s' "$rel" | sed 's/[][\.^$*+?(){}|]/\\&/g')\$")
  done < <(find "./$pkg" -type l -print0)
done

link_abs() {
  local entry pkg rel dest target
  for entry in "${abs_links[@]}"; do
    pkg=${entry%%$'\t'*} rel=${entry#*$'\t'}
    dest="$HOME/$rel" target=$(readlink "$pkg/$rel")
    [[ $(readlink "$dest" 2>/dev/null) == "$target" ]] && continue
    mkdir -p "$(dirname "$dest")"
    ln -sfn "$target" "$dest"
    echo "LINK $dest => $target"
  done
}

if ((delete)); then
  stow -D "${stow_args[@]}" "${pkgs[@]}"
  for entry in "${abs_links[@]}"; do
    dest="$HOME/${entry#*$'\t'}"
    [[ -L $dest ]] && rm "$dest"
  done
  exit 0
fi

if ((update)) && [[ -d .git ]]; then
  git pull --ff-only
fi

# Back up and remove whatever blocks stow, so the repo version wins.
moved=()
if ((force)); then
  backup="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
  mapfile -t conflicts < <(
    stow -n -R "${stow_args[@]}" "${pkgs[@]}" 2>&1 |
      sed -n -E \
        -e 's/^ *\* cannot stow .* over existing target (.+) since (neither a link nor a directory|it is not owned by stow).*$/\1/p' \
        -e 's/^ *\* existing target (is neither a link nor a directory|is not owned by stow): //p'
  )
  for rel in "${conflicts[@]}"; do
    [[ -e $HOME/$rel || -L $HOME/$rel ]] || continue
    mkdir -p "$backup/$(dirname "$rel")"
    mv "$HOME/$rel" "$backup/$rel"
    moved+=("$rel")
    echo "Backed up ~/$rel -> $backup/$rel"
  done
fi

# -R re-stows: it also links files added to a package since the last run and
# removes links to files that no longer exist. It is a plain install too.
if ! stow -R "${stow_args[@]}" "${pkgs[@]}"; then
  # stow aborts as a whole: put back what -f moved so nothing is lost
  for rel in "${moved[@]}"; do
    mkdir -p "$(dirname "$HOME/$rel")"
    [[ -e $HOME/$rel || -L $HOME/$rel ]] || mv "$backup/$rel" "$HOME/$rel"
  done
  echo "stow failed; files moved by -f were restored" >&2
  exit 1
fi
link_abs

# Neorg parser (cloned by hand, see README)
norg="$HOME/.config/nvim/lua/git/tree-sitter-norg"
if [[ -d $HOME/.config/nvim && ! -d $norg ]]; then
  git clone https://github.com/nvim-neorg/tree-sitter-norg.git "$norg"
fi

# ---- Things you still have to fill in by hand -------------------------------
notices=()
has_pkg() { local p; for p in "${pkgs[@]}"; do [[ $p == "$1" ]] && return 0; done; return 1; }

if has_pkg zsh && ! grep -qs '^[[:space:]]*export[[:space:]]\+CLAUDE_CODE_OAUTH_TOKEN=.\+' "$HOME/.zshrc.local"; then
  notices+=("~/.zshrc.local: falta (o no define CLAUDE_CODE_OAUTH_TOKEN). Créalo con: export CLAUDE_CODE_OAUTH_TOKEN=...  (genera uno nuevo con 'claude setup-token' y revoca el que se expuso)")
fi

for entry in "${abs_links[@]}"; do
  target=$(readlink "${entry%%$'\t'*}/${entry#*$'\t'}")
  [[ -e $target ]] || notices+=("~/${entry#*$'\t'}: apunta a $target, que no existe en este equipo. Cambia el enlace a otra imagen (ln -sfn <imagen> ~/${entry#*$'\t'})")
done

# Absolute /home/<someone-else>/ paths baked into the packages being installed
for pkg in "${pkgs[@]}"; do
  while IFS= read -r -d '' f; do
    grep -oE '/home/[^/ "]+/' "$f" | grep -vxF "$HOME/" >/dev/null &&
      notices+=("${f#./}: contiene rutas /home/<otro-usuario>/ fijas; ajústalas a $HOME")
  done < <(find "./$pkg" -type f -not -path '*/lua/git/*' -print0)
done

if ((${#notices[@]})); then
  [[ -t 2 ]] && { b=$'\e[1;33m' r=$'\e[0m'; } || b= r=
  {
    echo
    echo "${b}== Pendiente de rellenar/revisar ==${r}"
    for n in "${notices[@]}"; do echo "  ! $n"; done
  } >&2
fi

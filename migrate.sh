#!/usr/bin/env bash
# Migrate the system setup (apt packages, apt repositories, flatpak) between Debian installs.
# Usage: ./migrate.sh export            save the current system state to .migration/
#        ./migrate.sh import [-n]       restore it on this system (-n: dry run, change nothing)
# Data lives in .migration/ (hidden, so install.sh does not treat it as a stow package).
set -euo pipefail
cd "$(dirname "$0")"

dir=.migration
dry=0

die() { echo "error: $*" >&2; exit 1; }
log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
run() { if ((dry)); then echo "[dry-run] $*"; else "$@"; fi; }

export_all() {
  mkdir -p "$dir/apt" "$dir/flatpak"

  log "Packages (manually installed)"
  apt-mark showmanual | sort > "$dir/apt/manual.txt"
  apt-mark showhold   | sort > "$dir/apt/hold.txt"
  wc -l < "$dir/apt/manual.txt" | xargs echo "  packages:"

  log "APT repositories, keys and pinning"
  rm -rf "$dir/apt/etc"; mkdir -p "$dir/apt/etc"
  for p in sources.list sources.list.d keyrings trusted.gpg.d preferences.d apt.conf.d; do
    [[ -e /etc/apt/$p ]] && cp -a "/etc/apt/$p" "$dir/apt/etc/"
  done
  # apt.conf.d ships many distro files; keep only the ones not owned by a package
  if [[ -d $dir/apt/etc/apt.conf.d ]]; then
    for f in "$dir"/apt/etc/apt.conf.d/*; do
      [[ -e $f ]] || continue
      dpkg -S "/etc/apt/apt.conf.d/$(basename "$f")" >/dev/null 2>&1 && rm -f "$f"
    done
    rmdir --ignore-fail-on-non-empty "$dir/apt/etc/apt.conf.d"
  fi
  # Keys dropped by packages (e.g. vendor-repo-keyring.deb) come back when the package is installed
  (. /etc/os-release && echo "${VERSION_CODENAME:-}") > "$dir/apt/codename.txt"

  if command -v flatpak >/dev/null; then
    log "Flatpak"
    for scope in system user; do
      flatpak remotes "--$scope" --columns=name,url 2>/dev/null | sed '/^$/d' > "$dir/flatpak/remotes-$scope.txt" || true
      flatpak list "--$scope" --app --columns=origin,application 2>/dev/null | sed '/^$/d' > "$dir/flatpak/apps-$scope.txt" || true
      printf '  %s: %s remotes, %s apps\n' "$scope" \
        "$(wc -l < "$dir/flatpak/remotes-$scope.txt")" "$(wc -l < "$dir/flatpak/apps-$scope.txt")"
    done
  else
    log "flatpak not installed, skipping"
  fi

  log "Done. Commit .migration/ and run './migrate.sh import' on the new system."
}

import_all() {
  [[ -d $dir/apt ]] || die "$dir not found; run './migrate.sh export' on the old system first"
  command -v apt-get >/dev/null || die "apt not found; is this Debian?"
  local sudo=sudo; ((EUID == 0)) && sudo=
  ((dry)) || [[ -z $sudo ]] || command -v sudo >/dev/null || die "sudo is required"

  local old new
  old=$(cat "$dir/apt/codename.txt" 2>/dev/null || true)
  new=$(. /etc/os-release && echo "${VERSION_CODENAME:-}")
  if [[ -n $old && $old != "$new" ]]; then
    log "Codename differs (old: $old, new: $new)"
    echo "  Copying sources verbatim would point to the wrong release; main Debian"
    echo "  sources are skipped and only third-party repos/keys are restored."
  fi

  log "APT repositories and keys"
  local src=$dir/apt/etc
  if [[ -d $src ]]; then
    for p in keyrings trusted.gpg.d preferences.d apt.conf.d; do
      [[ -d $src/$p ]] || continue
      run $sudo mkdir -p "/etc/apt/$p"
      run $sudo cp -an "$src/$p/." "/etc/apt/$p/"
    done
    if [[ -d $src/sources.list.d ]]; then
      for f in "$src"/sources.list.d/*; do
        [[ -e $f ]] || continue
        t=/etc/apt/sources.list.d/$(basename "$f")
        # Skip the distro's own sources when the release changed
        if [[ -n $old && $old != "$new" ]] && grep -qE 'deb\.debian\.org|security\.debian\.org' "$f"; then
          echo "  skipped $(basename "$f") (Debian sources, different release)"; continue
        fi
        [[ -e $t ]] && { echo "  kept existing $(basename "$f")"; continue; }
        run $sudo cp -a "$f" "$t"
      done
    fi
    if [[ -f $src/sources.list && $old == "$new" ]] && grep -qE '^\s*deb ' "$src/sources.list"; then
      if ! grep -qE '^\s*deb ' /etc/apt/sources.list 2>/dev/null; then
        run $sudo cp -a "$src/sources.list" /etc/apt/sources.list
      fi
    fi
  fi
  run $sudo apt-get update

  log "Packages"
  local avail=() missing=() p
  while IFS= read -r p; do
    [[ -n $p ]] || continue
    if apt-cache show "$p" >/dev/null 2>&1; then avail+=("$p"); else missing+=("$p"); fi
  done < "$dir/apt/manual.txt"
  echo "  ${#avail[@]} available, ${#missing[@]} unavailable"
  if ((${#missing[@]})); then
    printf '%s\n' "${missing[@]}" > "$dir/apt/missing.txt"
    echo "  unavailable packages listed in $dir/apt/missing.txt"
  fi
  if ((${#avail[@]})); then
    run $sudo apt-get install -y "${avail[@]}"
  fi
  if [[ -s $dir/apt/hold.txt ]]; then
    run $sudo apt-mark hold $(cat "$dir/apt/hold.txt")
  fi

  if [[ -d $dir/flatpak ]] && compgen -G "$dir/flatpak/apps-*.txt" >/dev/null; then
    log "Flatpak"
    if ! command -v flatpak >/dev/null; then
      run $sudo apt-get install -y flatpak
    fi
    local scope name url origin app
    for scope in system user; do
      local flags=("--$scope")
      [[ -f $dir/flatpak/remotes-$scope.txt ]] && while IFS=$'\t' read -r name url; do
        [[ -n $name ]] || continue
        run flatpak remote-add "${flags[@]}" --if-not-exists "$name" "$url"
      done < "$dir/flatpak/remotes-$scope.txt"
      [[ -f $dir/flatpak/apps-$scope.txt ]] && while IFS=$'\t' read -r origin app; do
        [[ -n $app ]] || continue
        run flatpak install "${flags[@]}" -y --noninteractive "$origin" "$app" \
          || echo "  failed: $app" >&2
      done < "$dir/flatpak/apps-$scope.txt"
    done
  fi

  log "Done."
}

cmd=${1:-}; shift || true
while (($#)); do
  case $1 in
    -n|--dry-run) dry=1 ;;
    *) die "Unknown option: $1" ;;
  esac
  shift
done

case $cmd in
  export) export_all ;;
  import) import_all ;;
  -h|--help|help|"") sed -n '2,5p' "$0" | sed 's/^# \?//' ;;
  *) die "Unknown command: $cmd (use export or import)" ;;
esac

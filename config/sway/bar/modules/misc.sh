#!/usr/bin/env bash
# Processes, failed units and backup modules (sourced by ../bar.sh)

mod_procs() {
  borg=""
  others=""
  pgrep borgmatic >/dev/null && borg="󰸧 "
  pgrep -f "cluster_hermes_notify.sh" >/dev/null && others="[󰈈]"
}

# Failed systemd units (system + user). One failed unit is named in the bar; with
# several only the count is shown. Clicking the block lists them all.
mod_failed() {
  local -a units=()
  local u
  while read -r u _; do [[ -n $u ]] && units+=("$u"); done < <(systemctl --failed --no-legend --plain 2>/dev/null)
  while read -r u _; do [[ -n $u ]] && units+=("$u (user)"); done < <(systemctl --user --failed --no-legend --plain 2>/dev/null)
  failed=""
  failed_info="No failed units"
  ((${#units[@]} > 0)) || return
  printf -v failed_info '%s\n' "${units[@]}"
  failed_info=${failed_info%$'\n'}
  if ((${#units[@]} == 1)); then
    u=${units[0]}
    ((${#u} > 28)) && u="${u:0:27}…"
    failed="[󰀦 $u]"
  else
    failed="[󰀦 ${#units[@]}]"
  fi
}

# Age of the last successful backup (see BACKUP_STAMP in bar.sh)
mod_backup() {
  local m now h
  backup=""
  backup_c=""
  [[ -e $BACKUP_STAMP ]] || return
  m=$(stat -c %Y "$BACKUP_STAMP") || return
  printf -v now '%(%s)T' -1
  h=$(((now - m) / 3600))
  ((h >= BACKUP_WARN_H)) || return
  backup="[󰁯 $((h / 24))d]"
  backup_c=$RED
}

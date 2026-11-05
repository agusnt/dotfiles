#!/usr/bin/env bash
# Processes, failed units and backup modules (sourced by ../bar.sh)

mod_procs() {
  borg=""
  others=""
  pgrep borgmatic >/dev/null && borg="$ICON_BORG "
  pgrep -f "cluster_hermes_notify.sh" >/dev/null && others=$ICON_OTHERS
}

# Failed systemd units (system + user). One failed unit is named in the bar; with
# several only the count is shown. Clicking the block lists them all.
failed_prev=""
failed_seen=0

mod_failed() {
  local -a units=()
  local u new="" cur="|"
  while read -r u _; do [[ -n $u ]] && units+=("$u"); done < <(systemctl --failed --no-legend --plain 2>/dev/null)
  while read -r u _; do [[ -n $u ]] && units+=("$u (user)"); done < <(systemctl --user --failed --no-legend --plain 2>/dev/null)
  # Notify about units that were not failed on the previous check
  for u in "${units[@]}"; do
    [[ $failed_prev == *"|$u|"* ]] || new+="${new:+, }$u"
    cur+="$u|"
  done
  ((failed_seen)) && [[ -n $new ]] && notify -u critical "Unit failed" "$new"
  failed_prev=$cur
  failed_seen=1
  failed=""
  failed_info="No failed units"
  ((${#units[@]} > 0)) || return
  printf -v failed_info '%s\n' "${units[@]}"
  failed_info=${failed_info%$'\n'}
  if ((${#units[@]} == 1)); then
    u=${units[0]}
    ((${#u} > 28)) && u="${u:0:27}…"
    failed="$ICON_FAILED $u"
  else
    failed="$ICON_FAILED ${#units[@]}"
  fi
}

# Age of the last successful backup (see BACKUP_STAMP in bar.sh)
backup_mtime=""

mod_backup() {
  local m now h
  backup=""
  backup_c=""
  [[ -e $BACKUP_STAMP ]] || return
  m=$(stat -c %Y "$BACKUP_STAMP") || return
  [[ -n $backup_mtime && $m != "$backup_mtime" ]] && notify "Backup" "Backup completed"
  backup_mtime=$m
  printf -v now '%(%s)T' -1
  h=$(((now - m) / 3600))
  ((h >= BACKUP_WARN_H)) || return
  backup="$ICON_BACKUP $((h / 24))d"
  backup_c=$RED
}

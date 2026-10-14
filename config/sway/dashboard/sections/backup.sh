#!/usr/bin/env bash
# Backups sections: status/timer and borgmatic repository (sourced by dashboard.sh).

data_backup() {
  local next last res c=$GRN
  if [[ $(systemctl --user show backup.timer -p LoadState --value 2>/dev/null) != loaded ]]; then
    printf 'Timer     %sbackup.timer not found%s\n' "$DIMC" "$R"
    return
  fi
  next=$(systemctl --user show backup.timer -p NextElapseUSecRealtime --value)
  last=$(systemctl --user show backup.service -p ExecMainExitTimestamp --value)
  res=$(systemctl --user show backup.service -p Result --value)
  [[ $res == success ]] || c=$RED
  printf 'Next run  %s\n' "${next:-n/a}"
  printf 'Last run  %s %s(%s)%s\n' "${last:-n/a}" "$c" "${res:-n/a}" "$R"
}

sec_backup() {
  local m h age c=$GRN
  title "Backups"
  if [[ -e $BACKUP_STAMP ]]; then
    m=$(stat -c %Y "$BACKUP_STAMP")
    h=$(((EPOCHSECONDS - m) / 3600))
    ((h >= BACKUP_WARN_H)) && c=$RED
    if ((h >= 48)); then age="$((h / 24))d"; else age="${h}h"; fi
    printf 'Last OK   %s%s ago%s\n' "$c" "$age" "$R"
  else
    printf 'Last OK   %sno stamp file%s\n' "$DIMC" "$R"
  fi
  pgrep borgmatic >/dev/null && printf 'Running   %sbackup in progress%s\n' "$YEL" "$R"
  cached backup 60 data_backup
}

# borgmatic is slow (it opens the repository), so it runs in the background through
# cached(). One call at a time: two borgmatic runs on the same repository block each
# other on borg's lock. Newer borgmatic has repo-list/repo-info, older has list/info.
# stdin is closed so a passphrase prompt fails instead of hanging.
borgmatic_json() {
  # SIGINT (not TERM/KILL) so borg can release the repository lock before exiting
  timeout -s INT -k 10 45 borgmatic "$@" --json </dev/null 2>"$cache/borg.err"
}

data_borg() {
  local json info
  # A running backup holds the repository lock: do not compete with it
  if pgrep borgmatic >/dev/null || pgrep -x borg >/dev/null; then
    printf '%sbackup in progress, repository not queried%s\n' "$YEL" "$R"
    return
  fi
  json=$(borgmatic_json repo-list --last 5) || json=$(borgmatic_json list --last 5)
  if [[ -z $json ]]; then
    printf '%scould not read the repository%s\n' "$RED" "$R"
    # Last line of borgmatic's own error, cut to fit the column
    tail -n1 "$cache/borg.err" 2>/dev/null | cut -c1-$((COLW - 4))
    return
  fi
  info=$(borgmatic_json repo-info) || info=$(borgmatic_json info)
  [[ -n $info ]] || info='[]'

  # One block per repository (borgmatic may have several). Lines are tab separated:
  #   R location disk_GiB total_GiB   then   A start   (oldest first, as borg lists them)
  local kind a b c loc host path age hours col=$GRN first=1
  while IFS=$'\t' read -r kind a b c; do
    if [[ $kind == R ]]; then
      ((first)) || echo
      first=0
      loc=${a#ssh://}
      if [[ $a == ssh://* ]]; then host=${loc%%/*}; path=/${loc#*/}; else host=local; path=$a; fi
      printf '%s%s%s  %s\n' "$B" "$host" "$R" "$path"
      [[ -n $b ]] && printf '  Size   %s GiB on disk  (%s GiB before dedup)\n' "$b" "$c"
    else
      # Colour the age like the "Last OK" line: red once past BACKUP_WARN_H
      hours=$(((EPOCHSECONDS - $(date -d "$a" +%s 2>/dev/null || echo "$EPOCHSECONDS")) / 3600))
      ((hours < 0)) && hours=0
      col=$GRN
      ((hours >= BACKUP_WARN_H)) && col=$RED
      if ((hours >= 48)); then age="$((hours / 24))d"; else age="${hours}h"; fi
      printf '  %s  %s%s ago%s\n' "${a:0:16}" "$col" "$age" "$R"
    fi
  done < <(jq -r --argjson info "$info" '
    .[] | . as $r
    | ($info | map(select(.repository.id == $r.repository.id)) | .[0].cache.stats // {}) as $st
    | ["R", $r.repository.location,
       (if $st.unique_csize then ($st.unique_csize / 1073741824 * 10 | round / 10 | tostring) else "" end),
       (if $st.total_size then ($st.total_size / 1073741824 * 10 | round / 10 | tostring) else "" end)] | @tsv,
      ($r.archives | reverse | .[] | ["A", (.start | sub("T"; " "))] | @tsv)' <<<"$json" 2>/dev/null)
}

sec_borg() {
  title "Borgmatic"
  if ! command -v borgmatic >/dev/null; then
    printf '%sborgmatic not installed%s\n' "$DIMC" "$R"
    return
  fi
  cached borg 120 data_borg
}

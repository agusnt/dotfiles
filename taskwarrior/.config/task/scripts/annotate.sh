#!/usr/bin/env bash
# Annotate a task from a small floating prompt (taskwarrior-tui shortcut 3).
# The TUI captures the output of shortcuts, so the prompt runs in its own terminal.
# Usage: annotate.sh TASK_ID_OR_UUID

id=${1:?usage: ${0##*/} TASK_ID_OR_UUID}

if [[ ${1:-} == --prompt ]]; then
  id=$2
  desc=$(task rc.verbose=nothing "$id" _get description)
  printf 'Annotate: %s\n> ' "$desc"
  IFS= read -r note
  [[ -n $note ]] && task rc.confirmation=off "$id" annotate -- "$note"
  exit 0
fi

# Block until the prompt closes, so the TUI refreshes with the new annotation
exec foot -a sway-tasks-prompt "$0" --prompt "$id"

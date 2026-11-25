#!/usr/bin/env bash
# Add the +next tag if the task lacks it, remove it otherwise (taskwarrior-tui shortcut 2).
# Usage: toggle-next.sh TASK_ID_OR_UUID

id=${1:?usage: ${0##*/} TASK_ID_OR_UUID}
if [[ $(task rc.verbose=nothing "$id" +next count 2>/dev/null) -gt 0 ]]; then
  task rc.confirmation=off "$id" modify -next
else
  task rc.confirmation=off "$id" modify +next
fi

#!/usr/bin/env bash
# Start the task if it is stopped, stop it if it is running (taskwarrior-tui shortcut 1).
# The on-modify.timewarrior hook starts/stops the Timewarrior clock from this.
# Usage: toggle-start.sh TASK_ID_OR_UUID

id=${1:?usage: ${0##*/} TASK_ID_OR_UUID}
if [[ $(task rc.verbose=nothing "$id" +ACTIVE count 2>/dev/null) -gt 0 ]]; then
  task rc.confirmation=off "$id" stop
else
  task rc.confirmation=off "$id" start
fi

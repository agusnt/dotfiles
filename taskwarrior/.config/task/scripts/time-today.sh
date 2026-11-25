#!/usr/bin/env bash
# Show today's Timewarrior summary as a notification (taskwarrior-tui shortcut 4).
# Usage: time-today.sh [ignored task id]

summary=$(timew summary :day 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | grep -v '^$')
notify-send -t 10000 "Timewarrior · today" "${summary:-No time tracked today}"

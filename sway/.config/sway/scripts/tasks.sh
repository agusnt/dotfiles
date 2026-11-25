#!/usr/bin/env bash
# Toggle taskwarrior-tui in a floating terminal (app_id "sway-tasks").
# Usage: tasks.sh toggle

APP_ID=sway-tasks

if pgrep -f "foot.* -a $APP_ID|footclient.* -a $APP_ID" >/dev/null; then
  swaymsg "[app_id=\"$APP_ID\"] kill" >/dev/null 2>&1
  exit 0
fi

command -v taskwarrior-tui >/dev/null || { notify-send "taskwarrior-tui is not installed" 2>/dev/null; exit 1; }

# The TUI has no key list on screen: run it in a private tmux server whose status line
# shows the keys (full list: Tasks tab of the cheat sheet, or ? in the TUI)
if command -v tmux >/dev/null; then
  hints=' a add  e edit  m modify  A note  x done  d del  s start  u undo  / filter  r report  c context  1 clock  2 next  3 note  4 time  ? help  q quit'
  cmd=(tmux -L sway-tasks -f /dev/null new-session -s tasks taskwarrior-tui
    ';' set status on ';' set status-right '' ';' set status-style 'fg=colour245,bg=colour237'
    ';' set status-left-length 200 ';' set status-left "$hints")
else
  cmd=(taskwarrior-tui)
fi

if pgrep -f 'foot (-s|--server)' >/dev/null && command -v footclient >/dev/null; then
  exec footclient -E -a "$APP_ID" "${cmd[@]}"
fi
exec foot -a "$APP_ID" "${cmd[@]}"

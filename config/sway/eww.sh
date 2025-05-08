#!/bin/bash
SCREEN=DP-1
FILE="/tmp/eww_launch.dashboard"

## Run eww daemon if not running already
if ! pidof eww; then
  eww daemon
  sleep 1
fi

open_eww() {
  eww list-windows | while IFS= read -r window; do
    eww open "$window" --screen $SCREEN
  done
}

close_eww() {
  eww list-windows | while IFS= read -r window; do
    eww close "$window"
  done
}

## Launch or close widgets accordingly
if [[ ! -f "$FILE" ]]; then
  touch "$FILE"
  open_eww
else
  close_eww
  rm $FILE
fi

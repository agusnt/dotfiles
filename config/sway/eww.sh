#!/bin/bash
SCREEN=DP-1
FILE="/tmp/eww_launch.dashboard"

## Run eww daemon if not running already
if ! pidof eww; then
  eww daemon
  sleep 1
fi

## Launch or close widgets accordingly
if [[ ! -f "$FILE" ]]; then
  touch "$FILE"
  eww open dashboard --screen $SCREEN
else
  eww close dashboard
  rm $FILE
fi

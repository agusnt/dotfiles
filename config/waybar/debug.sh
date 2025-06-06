#!/usr/bin/bash

CONFIG_FILES="$HOME/.config/waybar/config $HOME/.config/waybar/style.css"

trap "killall waybar" EXIT

while true; do
  waybar --log-level=trace &
  inotifywait -e create,modify $CONFIG_FILES
  killall waybar
done

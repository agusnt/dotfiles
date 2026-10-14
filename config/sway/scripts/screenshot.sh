#!/usr/bin/env bash
# No arguments: full screen. Any argument: region (slurp).

file="/tmp/$(date +%Y-%m-%d_%H:%M:%S).png"

if [ "$#" -ge 1 ]; then
  region=$(slurp) || exit 0 # selection cancelled
  grim -g "$region" "$file"
else
  grim "$file"
fi

notify-send -e "Screenshot saved at: $file"

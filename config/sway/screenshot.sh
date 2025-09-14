#!/usr/bin/bash


ffile="/tmp/$(date +%Y-%m-%d_%H:%M:%S).png"

if [ "$#" -eq 1 ]; then
  grim -g "$(slurp)" "$ffile"
else
  grim "$ffile"
fi

notify-send -e "Screenshot saved at: $ffile"

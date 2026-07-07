#!/usr/bin/env bash

[ "$1" == "up" ] && brightnessctl s 5%+ >/dev/null 2>&1;
[ "$1" == "down" ] && brightnessctl s 5%- >/dev/null 2>&1;

echo "scale=2; ($(brightnessctl g) / $(brightnessctl m)) * 100" \
  | bc -l | cut -d'.' -f1 > "$XDG_RUNTIME_DIR"/wob.sock


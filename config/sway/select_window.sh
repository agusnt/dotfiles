#!/usr/bin/bash

# swaymsg workspace $(
~/.config/sway/list_windows.py |
  tofi --width 90% --height 60% --font-size 12 |
  cut -d'|' -f2 | cut -d':' -f1

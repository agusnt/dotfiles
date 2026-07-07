#!/usr/bin/env bash

[ "$1" == "up" ] && wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+ >/dev/null 2>&1;
[ "$1" == "down" ] && wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%- >/dev/null 2>&1;

wpctl get-volume @DEFAULT_SINK@ \
  | cut -d' ' -f 2 | cut -d'.' -f2 > "$XDG_RUNTIME_DIR"/wob.sock


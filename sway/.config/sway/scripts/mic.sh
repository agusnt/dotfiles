#!/usr/bin/env bash
# Toggle the microphone mute. With "sync" it only sets the LED to the current state.
. "$(dirname "$(readlink -f "$0")")/../lib/lib.sh"

[ "$1" = sync ] || wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED && muted=1 || muted=0
led_set micmute "$muted"

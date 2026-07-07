#!/usr/bin/env bash

# Toggle microphone
pactl set-source-mute @DEFAULT_SOURCE@ toggle
# Muted
MUTED=$(pactl get-source-mute @DEFAULT_SOURCE@ | grep -c "Mute: yes")
# Led
brightnessctl --device='platform::micmute' set $MUTED > /dev/null 2>&1

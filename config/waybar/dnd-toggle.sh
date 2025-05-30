#!/bin/bash

if [[ "$(makoctl mode)" == "default" ]]; then
  makoctl mode -a dnd >/dev/null 2>&1
  makoctl mode -r default >/dev/null 2>&1
  notify-send "Notificacions On"
else
  makoctl mode -a default >/dev/null 2>&1
  makoctl mode -r dnd >/dev/null 2>&1
fi
pkill -RTMIN+8 waybar

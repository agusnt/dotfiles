#!/usr/bin/env bash

rm /run/user/1000/pipectl.1000.wl-present.pipe >/dev/null 2>&1

if ! pkill wl-mirror; then
  for display in $(swaymsg -t get_outputs | jq '.[] | (.name)'); do
    display=${display//\"/}
    if [[ "$display" != "eDP-1" ]]; then
      wl-present mirror eDP-1 --fullscreen-output "$display" --fullscreen
    fi
  done
fi

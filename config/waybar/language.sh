#!/bin/bash

layout=$(swaymsg -t get_inputs | grep -A 10 "Keyboard" | grep "xkb_active_layout_name")

if [[ "$layout" =~ "US" ]]; then
  swaymsg input type:keyboard xkb_layout es
elif [[ "$layout" =~ "Spanish" ]]; then
  swaymsg input type:keyboard xkb_layout us
fi


#!/bin/bash

exit
layout=$(setxkbmap -query 2>/dev/null | grep "layout" | rev | cut -d' ' -f1 | rev)

if [[ "$layout" =~ "us" ]]; then
  swaymsg input type:keyboard xkb_layout es
elif [[ "$layout" =~ "Spanish" ]]; then
  swaymsg input type:keyboard xkb_layout us
fi

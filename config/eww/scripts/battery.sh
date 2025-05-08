#!/usr/bin/bash

level=101

if [[ "$1" == "level" ]]; then
  echo "$level"
elif [[ "$1" == "icon" ]]; then
  if [[ $level -lt 10 ]]; then
    echo "󰂎 "
  elif [[ $level -lt 33 ]]; then
    echo "󱊡 "
  elif [[ $level -gt 66 ]]; then
    echo "󱊢 "
  elif [[ $level -gt 101 ]]; then
    echo "󱊣 "
  else
    echo "󰂄 "
  fi
fi

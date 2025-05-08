#!/usr/bin/bash

level=100

if [[ "$1" == "level" ]]; then
  echo "$level"
elif [[ "$1" == "icon" ]]; then
  if [[ $level -lt 33 ]]; then
    echo " 󰃞 "
  elif [[ $level -lt 66 ]]; then
    echo " 󰃝 "
  else
    echo " 󰃠 "
  fi
fi

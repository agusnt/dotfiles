#!/bin/bash

F=/tmp/dnd-wlr.out
if [[ "$(makoctl mode)" == "default" ]]; then
  makoctl mode -a dnd >/dev/null 2>&1
  makoctl mode -r default >/dev/null 2>&1
  echo "Y" >> $F
fi
pkill -RTMIN+1 waybar

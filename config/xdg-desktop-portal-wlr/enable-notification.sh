#!/bin/bash

F=/tmp/dnd-wlr.out

if grep -q "Y" $F; then
  makoctl mode -a default >/dev/null 2>&1
  makoctl mode -r dnd >/dev/null 2>&1
  rm $F
fi

pkill -RTMIN+1 waybar

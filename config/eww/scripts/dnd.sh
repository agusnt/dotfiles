#!/bin/bash

icon=" "
if [[ "$(makoctl mode)" == "default" ]]; then
  icon="󰂚 "
elif [[ "$(makoctl mode)" == "dnd" ]]; then
  icon="󰂛 "
fi
echo "$icon"

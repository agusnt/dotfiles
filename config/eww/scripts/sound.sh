#!/usr/bin/bash

muted=$(pactl get-sink-mute @DEFAULT_SINK@ | cut -d' ' -f2)
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | head -n1 | cut -d'/' -f2 | cut -d'%' -f1 | tr -d ' ')

set_files() {
  #Set the icons and vols
  ficon="/tmp/sound-icon"
  fvol="/tmp/sound-vol"

  if [ ! -f $ficon ]; then echo " " >$ficon; fi
  if [ ! -f $fvol ]; then echo "0 " >$fvol; fi

  if [[ "$muted" == "yes" ]]; then
    sed -i "1c\\󰖁 " $ficon
  else
    if [[ $volume -lt 33 ]]; then
      sed -i "1c\\󰕿 " $ficon
    elif [[ $volume -lt 66 ]]; then
      sed -i "1c\\󰖀 " $ficon
    else
      sed -i "1c\\󰕾 " $ficon
    fi
  fi

  volume=$(echo "$volume" | cut -d'%' -f1)
  sed -i "1c\\$volume" $fvol
}

# Mute/Unmute
if [[ "$1" == "toggle" ]]; then
  if [[ "$muted" == "yes" ]]; then
    pactl set-sink-mute @DEFAULT_SINK@ 0
    muted="no"
  else
    pactl set-sink-mute @DEFAULT_SINK@ 1
    muted="yes"
  fi
# Volume control
elif [[ "$1" == "up" ]]; then
  if [[ $volume -lt 100 ]]; then
    if [[ $volume -gt 95 ]]; then volume=95; fi
    volume=$((volume + 5))%
    pactl set-sink-volume @DEFAULT_SINK@ $volume
  fi
elif [[ "$1" == "down" ]]; then
  if [[ $volume -gt 0 ]]; then
    if [[ $volume -lt 5 ]]; then volume=5; fi
    volume=$((volume - 5))%
    pactl set-sink-volume @DEFAULT_SINK@ $volume
  fi
fi

# Set the fiels
set_files

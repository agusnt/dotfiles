#!/usr/bin/bash
if [[ "$1" == "up" ]]; then
  brightnessctl set +5%
elif [[ "$1" == "down" ]]; then
  brightnessctl set 5-%
fi


sleep 0.5s
level=$(brightnessctl | grep "%" | cut -d'(' -f2 | cut -d'%' -f1)
echo "$level" >/tmp/bright.level

if [[ $level -lt 33 ]]; then
  echo " 󰃞 " >/tmp/bright.icon
elif [[ $level -lt 66 ]]; then
  echo " 󰃝 " >/tmp/bright.icon
else
  echo " 󰃠 " >/tmp/bright.icon
fi



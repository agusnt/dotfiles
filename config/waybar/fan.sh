#!/bin/bash

level=$(grep "level:" /proc/acpi/ibm/fan)
level=$(echo $level | sed 's/[ \t]*$//' | cut -d' ' -f2)
speed=$(grep "speed:" /proc/acpi/ibm/fan)
speed=$(echo $speed | sed 's/[ \t]*$//' | cut -d' ' -f2)

if [[ $level == "0" ]]; then
  echo "{\"text\": \"󰠝 \", \"tooltip\": \"Speed: $speed, Level: $level\"}"
elif [[ $level == "1" ]] || [[ $level == "2" ]]; then
  echo "{\"text\": \"󱑲 \", \"tooltip\": \"Speed: $speed, Level: $level\"}"
elif [[ $level == "3" ]] || [[ $level == "4" ]] || [[ $level == "5" ]]; then
  echo "{\"text\": \"󱑳 \", \"tooltip\": \"Speed: $speed, Level: $level\"}"
elif [[ $level == "6" ]] || [[ $level == "7" ]]; then
  echo "{\"text\": \"󱑴 \", \"tooltip\": \"Speed: $speed, Level: $level\"}"
elif [[ $level == "auto" ]]; then
  echo "{\"text\": \"󱜝 \", \"tooltip\": \"Speed: $speed, Level: $level\"}"
elif [[ $level == "disengaged" ]] || [[ $level == "full-level" ]]; then
  echo "{\"text\": \"󱑬 \", \"tooltip\": \"Speed: $speed, Level: $level\"}"
fi

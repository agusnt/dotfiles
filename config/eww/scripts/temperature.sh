#!/bin/bash

# Check if we have internet
if ! wget -q --spider http://google.com; then
  echo "󱘖 "
  exit
fi

# Get actual position
pos=$(curl -s ipinfo.io/loc)
lat=$(echo "$pos" | cut -d',' -f1)
lon=$(echo "$pos" | cut -d',' -f2)

# Get weather
weather=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&&hourly=apparent_temperature,weather_code&timezone=auto&forecast_days=1")

# info
hour=$(date +%H)
tmp=$(echo "$weather" | jq '.hourly.apparent_temperature' | sed -n "$hour"p | cut -d',' -f1 | awk '{$1=$1;print}')
echo "$tmpC" >/tmp/temperature

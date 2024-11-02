#!/bin/bash

# Check if we have internet
wget -q --spider http://google.com
if [ $? -ne 0 ]; then
    echo "󱘖 "
    exit
fi

# Codes
WEATHER_CODES=(
    [0]='󰖙'
    [1]='󰖙'
    [2]='󰖕'
    [3]='󰖐' #cloudy
    [45]='󰖑' #foggy
    [48]='󰖑' #rime fog
    [51]='󰖖' #light drizzel
    [53]='󰖖' #drizzel
    [55]='󰖖' #heavy drizzel
    [56]='󰖖' #light freezing drizzel
    [57]='󰖖' #freezing drizzel
    [61]='󰖗' #light rain
    [63]='󰖖' #rain
    [65]='󰖖' #heavy rain
    [66]='󰖗' #light freezing rain
    [67]='󰖖' #freezing rain
    [71]='' #light snow
    [73]='' #snow
    [75]='󰼩' #heavy snow
    [77]='' #snow grains
    [80]='󰖖' #light showers
    [81]='󰖖' #showers
    [82]='󰼶' #heavy showers
    [85]='󰖘' #light snow showers
    [86]='󰖘' #snow showers
    [95]='󰖓' #thunderstorm
    [96]='󰖓' #light thunderstorm with hail
    [99]='󰖓' #thunderstorm with hail
)

# Get actual position
pos=$(curl -s ipinfo.io/loc)
lat=$(echo $pos | cut -d',' -f1)
lon=$(echo $pos | cut -d',' -f2)

# Get weather
weather=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&&hourly=apparent_temperature,weather_code&timezone=auto&forecast_days=1")

# info
hour=$(( $(date +%H) + 2 ))
tmp=$(echo $weather | jq '.hourly.apparent_temperature' | sed -n "$hour"p | cut -d',' -f1 | awk '{$1=$1;print}')
weather=$(echo $weather | jq '.hourly.weather_code' | sed -n "$hour"p | cut -d',' -f1)
echo "${WEATHER_CODES[$weather]} ($tmpC)"

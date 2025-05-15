#!/bin/bash

# This that I have to poll from time to time
DIR="$HOME/.config/eww/scripts"

$($DIR/weather.sh)
$($DIR/location.sh)
$($DIR/temperature.sh)

borgmatic list 2>&1 | tail -n1 | cut -d',' -f2 | cut -d' ' -f2-3 >/tmp/lbackup

#!/bin/bash

# This that I have to poll from time to time
DIR="$HOME/.config/eww/scripts"

$($DIR/weather.sh)
$($DIR/location.sh)
$($DIR/temperature.sh)

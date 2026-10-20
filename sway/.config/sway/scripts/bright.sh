#!/usr/bin/env bash
# Usage: bright.sh up|down
. "$(dirname "$(readlink -f "$0")")/../lib/lib.sh"

STEP=5%

case $1 in
up) brightnessctl -q set "$STEP"+ ;;
down) brightnessctl -q set "$STEP"- ;;
esac

# brightnessctl -m: device,class,current,percentage,max
IFS=, read -r _ _ _ pct _ < <(brightnessctl -m)
wob_send "${pct%\%}"

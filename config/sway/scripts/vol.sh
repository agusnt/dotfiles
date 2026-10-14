#!/usr/bin/env bash
# Usage: vol.sh up|down|mute
. "$(dirname "$(readlink -f "$0")")/../lib/lib.sh"

SINK=@DEFAULT_AUDIO_SINK@
STEP=1%

case $1 in
up) wpctl set-volume -l 1.0 "$SINK" "$STEP"+ >/dev/null 2>&1 ;;
down) wpctl set-volume "$SINK" "$STEP"- >/dev/null 2>&1 ;;
mute) wpctl set-mute "$SINK" toggle >/dev/null 2>&1 ;;
esac

read -r _ vol flag < <(wpctl get-volume "$SINK")
vol=${vol/./}
vol=$((10#${vol:-0}))
if [[ $flag == *MUTED* ]]; then
  led_set mute 1
  wob_send 0
else
  led_set mute 0
  wob_send "$vol"
fi

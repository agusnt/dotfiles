#!/usr/bin/env bash
# Lid switch handler. Usage: lid.sh close|open
# close: lock the screen and, if another output is active (docked), disable the
#        internal one. Without an external display logind suspends as usual.
# open:  re-enable the internal display.
. "$(dirname "$(readlink -f "$0")")/../lib/lib.sh"

internal=$(internal_output) || exit 0

case $1 in
close)
  # --reload re-runs this at sway startup with the lid already closed: don't lock at login
  up=$(ps -o etimes= -C sway | sort -n | head -1)
  [ "${up:-999}" -lt 30 ] || "$(dirname "$(readlink -f "$0")")/lock.sh"
  others=$(swaymsg -t get_outputs | jq --arg i "$internal" '[.[] | select(.active and .name != $i)] | length')
  [ "$others" -gt 0 ] && swaymsg output "$internal" disable
  ;;
open)
  swaymsg output "$internal" enable
  ;;
esac

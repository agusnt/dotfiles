#!/usr/bin/env bash
# Turn all displays on/off. Usage: display.sh on|off
# Uses "output * power" (sway >= 1.8) and falls back to the older "dpms".
swaymsg "output * power $1" >/dev/null 2>&1 || swaymsg "output * dpms $1"

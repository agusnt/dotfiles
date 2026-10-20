#!/usr/bin/env bash
# Common functions for the sway scripts (use with `source`).

# wob_send VALUE: send a value to wob, only if its socket is active.
# wob is socket-activated (wob.socket), so it is not running until the first
# write: do not check that the process exists.
wob_send() {
  local sock="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/wob.sock"
  [ -p "$sock" ] && printf '%s\n' "$1" >"$sock"
}

# led_set NAME VALUE: set the "*::NAME" LED (micmute, mute...) if the machine has it
led_set() {
  local d
  for d in /sys/class/leds/*::"$1"; do
    [ -e "$d" ] && brightnessctl -q --device="${d##*/}" set "$2" >/dev/null 2>&1
  done
}

# internal_output: print the name of the built-in display (eDP-*, LVDS-* or DSI-*),
# even when it is currently disabled; fails if the machine has none
internal_output() {
  swaymsg -t get_outputs | jq -r '.[].name | select(test("^(eDP|LVDS|DSI)"))' | head -n1 | grep .
}

#!/usr/bin/env bash
# Mirror the internal display on the other outputs (if already mirroring, turn it off).
. "$(dirname "$(readlink -f "$0")")/../lib/lib.sh"

rm -f "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/pipectl.$(id -u).wl-present.pipe"

pkill wl-mirror && exit 0

internal=$(internal_output) || exit 0

while read -r o; do
  [ "$o" != "$internal" ] && wl-present mirror "$internal" --fullscreen-output "$o" --fullscreen
done < <(swaymsg -t get_outputs | jq -r '.[] | select(.active) | .name')

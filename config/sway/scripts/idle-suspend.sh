#!/usr/bin/env bash
# Suspend after a long idle time, but only on battery: with the charger
# plugged in (or on a machine without battery) it does nothing.

shopt -s nullglob
bats=(/sys/class/power_supply/BAT*)
((${#bats[@]})) || exit 0

for ps in /sys/class/power_supply/*; do
  read -r type <"$ps/type" 2>/dev/null
  [[ $type == Mains ]] || continue
  read -r online <"$ps/online" 2>/dev/null
  [[ $online == 1 ]] && exit 0
done

exec systemctl suspend

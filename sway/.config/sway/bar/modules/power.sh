#!/usr/bin/env bash
# Battery module (sourced by ../bar.sh)

bat=(/sys/class/power_supply/BAT*)
bat_notified=0

mod_battery() {
  local d=${bat[0]} cap status now=0 full=0 rate=0 mins icon time=""
  local icons=(󰁺 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)
  battery=""
  [[ -d $d ]] || return
  read -r cap <"$d/capacity"
  read -r status <"$d/status"
  if [[ -r $d/energy_now ]]; then
    read -r now <"$d/energy_now"
    read -r full <"$d/energy_full"
    read -r rate <"$d/power_now"
  elif [[ -r $d/charge_now ]]; then
    read -r now <"$d/charge_now"
    read -r full <"$d/charge_full"
    read -r rate <"$d/current_now"
  fi
  if ((rate > 0)); then
    case $status in
    Discharging) mins=$((now * 60 / rate)) ;;
    esac
    [[ -n $mins ]] && printf -v time ' %dh%02dm' $((mins / 60)) $((mins % 60))
  fi
  icon=${icons[cap / 10]}
  [[ $status == Charging ]] && icon="󰂄"
  printf -v battery '[%s %3d%%%s]' "$icon" "$cap" "$time"
  heat_low "$cap" "$BAT_WARN" "$BAT_CRIT"
  battery_ic=$REPLY
  battery_info="$status, $cap%${time:+,$time left}"
  if [[ $status == Discharging ]]; then
    if ((cap <= BAT_CRIT && !bat_notified)); then
      bat_notified=1
      notify -u critical "Low battery" "$cap% remaining"
    fi
  fi
  [[ $status != Discharging ]] && bat_notified=0
}

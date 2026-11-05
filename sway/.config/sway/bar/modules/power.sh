#!/usr/bin/env bash
# Battery module (sourced by ../bar.sh)

bat=(/sys/class/power_supply/BAT*)
bat_notified=0
bat_full_notified=1 # 1 at start: no notice if the battery is already full when the bar starts

mod_battery() {
  local d=${bat[0]} cap status now=0 full=0 rate=0 mins="" icon time="" label=left
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
    Charging)
      mins=$(((full - now) * 60 / rate))
      label="until full"
      ;;
    esac
    [[ -n $mins ]] && printf -v time ' %dh%02dm' $((mins / 60)) $((mins % 60))
  fi
  icon=${ICON_BAT[cap / 10]}
  case $status in
  Charging) icon=$ICON_BAT_CHARGE ;;
  Full | "Not charging") icon=$ICON_BAT_PLUG ;;
  esac
  printf -v battery '%s %3d%%%s' "$icon" "$cap" "$time"
  heat_low "$cap" "$BAT_WARN" "$BAT_CRIT"
  battery_ic=$REPLY
  battery_info="$status, $cap%${time:+,$time $label}"
  if [[ $status == Discharging ]]; then
    if ((cap <= BAT_CRIT && !bat_notified)); then
      bat_notified=1
      notify -u critical "Low battery" "$cap% remaining"
    fi
  fi
  [[ $status != Discharging ]] && bat_notified=0
  # Charge complete (useful with a charge limit): one notice per charge
  if ((cap >= 100)) && [[ $status != Discharging ]]; then
    ((bat_full_notified)) || notify "Battery full" "You can unplug the charger"
    bat_full_notified=1
  elif ((cap < 100)) || [[ $status == Discharging ]]; then
    bat_full_notified=0
  fi
}

# Power profile (power-profiles-daemon): icon only, name in $gov_info (shown on
# click). power-saver / balanced / performance are read from the ACPI platform
# profile (what powerprofilesctl sets, no process spawned); without it, from the
# cpufreq governor + EPP.
prof_file=/sys/firmware/acpi/platform_profile
gov_file=/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
epp_file=/sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference

# Map the platform profile / cpufreq governor + EPP to a profile name
gov_name() {
  local p g epp=""
  if [[ -r $prof_file ]]; then
    read -r p <"$prof_file"
    case $p in
    low-power | quiet | cool) REPLY=power-saver ;;
    balanced) REPLY=balanced ;;
    performance | balanced-performance) REPLY=performance ;;
    *) REPLY=$p ;;
    esac
  elif [[ -r $gov_file ]]; then
    read -r g <"$gov_file"
    [[ -r $epp_file ]] && read -r epp <"$epp_file"
    if [[ $g == performance || $epp == performance ]]; then
      REPLY=performance
    elif [[ $g == schedutil || $g == ondemand || $epp == balance_* || $epp == default ]]; then
      REPLY=balanced
    else
      REPLY=power-saver
    fi
  else
    return 1
  fi
}

mod_gov() {
  local icon
  gov=""
  gov_name || return
  case $REPLY in
  power-saver) icon=$ICON_GOV_SAVER ;;
  balanced) icon=$ICON_GOV_BALANCED ;;
  performance) icon=$ICON_GOV_PERF ;;
  *) icon=$ICON_GOV_UNKNOWN ;;
  esac
  gov=$icon
  gov_info=$REPLY
}

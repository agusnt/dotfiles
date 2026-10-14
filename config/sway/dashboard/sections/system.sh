#!/usr/bin/env bash
# System section (sourced by dashboard.sh).

kernel=$(uname -r)
cores=$(nproc)

data_disk() {
  local seen=" " target size used pct label
  while read -r target size used pct; do
    [[ ${pct%\%} =~ ^[0-9]+$ ]] || continue
    [[ $seen == *" $target "* ]] && continue # $HOME on the same filesystem as /
    seen+="$target "
    label=$target
    [[ $target == "$HOME" ]] && label="~ (home)"
    printf '%-9s %6s / %-6s ' "$label" "$used" "$size"
    pct_color "${pct%\%}"
    echo
  done < <(df -h --output=target,size,used,pcent / "$HOME" 2>/dev/null)
}

data_vol() {
  local v flag
  read -r _ v flag < <(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null) || return
  v=${v/./}
  printf 'Volume    %d%%%s\n' "$((10#${v:-0}))" "${flag:+ muted}"
}

data_failed() {
  local u scope
  for scope in system user; do
    while read -r u _; do
      [[ -n $u ]] && printf '%s%s%s %s(%s)%s\n' "$RED" "$u" "$R" "$DIMC" "$scope" "$R"
    done < <(systemctl $([[ $scope == user ]] && echo --user) --failed --no-legend --plain 2>/dev/null)
  done
}

data_updates() {
  local n
  n=$(apt-get -s full-upgrade 2>/dev/null | grep -c '^Inst')
  if ((n > 0)); then printf 'Updates   %s%d pending%s\n' "$YEL" "$n" "$R"; else printf 'Updates   %sup to date%s\n' "$GRN" "$R"; fi
}

# A reboot is needed when apt asks for it or a newer kernel (same flavour) is installed
data_reboot() {
  local running=$(uname -r) newest
  newest=$(ls -1 /lib/modules 2>/dev/null | grep -- "-${running##*-}\$" | sort -V | tail -n1)
  if [[ -e /var/run/reboot-required ]] || [[ -n $newest && $newest != "$running" ]]; then
    printf 'Reboot    %sneeded%s  (running %s, installed %s)\n' "$YEL" "$R" "$running" "${newest:-?}"
  else
    printf 'Reboot    %snot needed%s\n' "$GRN" "$R"
  fi
}

sec_system() {
  local up d h m l1 l5 l15 k v total=0 avail=0 stot=0 sfree=0
  title "System"

  read -r up _ </proc/uptime
  up=${up%.*}
  d=$((up / 86400))
  h=$((up % 86400 / 3600))
  m=$((up % 3600 / 60))
  printf 'Uptime    %dd %dh %dm   %s%s%s\n' "$d" "$h" "$m" "$DIMC" "$kernel" "$R"

  read -r l1 l5 l15 _ </proc/loadavg
  printf 'Load      %s %s %s  (%d cores)\n' "$l1" "$l5" "$l15" "$cores"

  while read -r k v _; do
    case $k in
    MemTotal:) total=$v ;;
    MemAvailable:) avail=$v ;;
    SwapTotal:) stot=$v ;;
    SwapFree:)
      sfree=$v
      break
      ;;
    esac
  done </proc/meminfo
  if ((total)); then
    printf 'Memory    %s / %s  ' "$(kib_gib $((total - avail)))" "$(kib_gib "$total")"
    pct_color $(((total - avail) * 100 / total))
    echo
  fi
  if ((stot)); then
    printf 'Swap      %s / %s  ' "$(kib_gib $((stot - sfree)))" "$(kib_gib "$stot")"
    pct_color $(((stot - sfree) * 100 / stot))
    echo
  fi

  cached disk 30 data_disk
  cached vol 5 data_vol
  cached updates 1800 data_updates
  cached reboot 60 data_reboot
}

# sec_hardware: CPU temperature, frequency and fans
sec_hardware() {
  local n k t="" f fan i=0 sum=0 cnt=0
  title "Hardware"

  # CPU temperature: hwmon (k10temp/coretemp) first, else thermal_zone0
  for n in /sys/class/hwmon/hwmon*; do
    [[ -r $n/name ]] || continue
    read -r k <"$n/name"
    [[ $k == k10temp || $k == coretemp || $k == zenpower ]] && read -r t <"$n/temp1_input" && break
  done
  [[ -z $t && -r /sys/class/thermal/thermal_zone0/temp ]] && read -r t </sys/class/thermal/thermal_zone0/temp
  if [[ -n $t ]]; then
    t=$((t / 1000))
    printf 'Temp      '
    if ((t >= 80)); then printf '%s%d°C%s\n' "$RED" "$t" "$R"; elif ((t >= 70)); then printf '%s%d°C%s\n' "$YEL" "$t" "$R"; else printf '%d°C\n' "$t"; fi
  fi

  # Average current CPU frequency
  for f in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_cur_freq; do
    [[ -r $f ]] || continue
    read -r k <"$f"
    sum=$((sum + k))
    cnt=$((cnt + 1))
  done
  ((cnt)) && printf 'CPU freq  %d MHz  (avg of %d cores)\n' $((sum / cnt / 1000)) "$cnt"

  # Fans (every hwmon fan*_input)
  for fan in /sys/class/hwmon/hwmon*/fan*_input; do
    [[ -r $fan ]] || continue
    read -r k <"$fan"
    i=$((i + 1))
    printf 'Fan %d     %s RPM\n' "$i" "$k"
  done
  ((i)) || printf 'Fans      %snone reported%s\n' "$DIMC" "$R"
}

# sec_power: battery gauge, power draw, remaining time, health and charge limits
sec_power() {
  local d n cap status now=0 full=0 design=0 rate=0 cyc="" mins
  local ac="" limit=""
  title "Power"

  for n in /sys/class/power_supply/BAT*; do
    [[ -r $n/capacity ]] && d=$n && break
  done
  if [[ -z $d ]]; then
    printf '%sno battery%s\n' "$DIMC" "$R"
    return
  fi
  read -r cap <"$d/capacity"
  read -r status <"$d/status"
  printf 'Battery   %s  %s\n' "$(bat_gauge "$cap")" "$status"

  if [[ -r $d/energy_now ]]; then
    read -r now <"$d/energy_now"
    read -r full <"$d/energy_full"
    read -r design <"$d/energy_full_design"
    read -r rate <"$d/power_now"
  elif [[ -r $d/charge_now ]]; then
    read -r now <"$d/charge_now"
    read -r full <"$d/charge_full"
    read -r design <"$d/charge_full_design"
    read -r rate <"$d/current_now"
  fi
  if ((rate > 0)); then
    # Power is in µW only for energy_* files; charge_* files give µA (shown as is)
    [[ -r $d/energy_now ]] && printf 'Draw      %d.%d W\n' $((rate / 1000000)) $((rate / 100000 % 10))
    case $status in
    Discharging) mins=$((now * 60 / rate)) ;;
    Charging) ((full > now)) && mins=$(((full - now) * 60 / rate)) ;;
    esac
    if [[ -n $mins ]]; then
      printf '%-9s %dh%02dm\n' "$([[ $status == Charging ]] && echo 'To full' || echo 'Remaining')" $((mins / 60)) $((mins % 60))
    fi
  fi
  ((design > 0 && full > 0)) && printf 'Health    %d%% of design capacity\n' $((full * 100 / design))
  [[ -r $d/cycle_count ]] && read -r cyc <"$d/cycle_count" && printf 'Cycles    %s\n' "$cyc"
  if [[ -r $d/charge_control_end_threshold ]]; then
    read -r limit <"$d/charge_control_end_threshold"
    printf 'Limit     charges up to %s%%\n' "$limit"
  fi
  for n in /sys/class/power_supply/AC* /sys/class/power_supply/ADP*; do
    [[ -r $n/online ]] && read -r ac <"$n/online" && break
  done
  [[ -n $ac ]] && printf 'AC        %s\n' "$([[ $ac == 1 ]] && echo plugged || echo unplugged)"
}

# sec_failed: names of the failed systemd units (system and user)
sec_failed() {
  local out
  title "Failed units"
  out=$(cached failed 30 data_failed)
  if [[ -z $out ]]; then printf '%snone%s\n' "$GRN" "$R"; else printf '%s\n' "$out"; fi
}

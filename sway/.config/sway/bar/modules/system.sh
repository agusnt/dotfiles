#!/usr/bin/env bash
# CPU, RAM, temperature and disk modules (sourced by ../bar.sh)

# CPU temperature sensor: hwmon (k10temp/coretemp) > thermal_zone > zone0
temp_f=/sys/class/thermal/thermal_zone0/temp
for h in /sys/class/hwmon/hwmon*; do
  [[ -r $h/name ]] && read -r n <"$h/name"
  case $n in k10temp | coretemp | zenpower) temp_f=$h/temp1_input && break ;; esac
done
if [[ $temp_f == */thermal_zone0/temp ]]; then
  for z in /sys/class/thermal/thermal_zone*; do
    [[ -r $z/type ]] && read -r n <"$z/type"
    case $n in x86_pkg_temp | cpu_thermal) temp_f=$z/temp && break ;; esac
  done
fi

# Incremental icons: pie slices for usage, thermometer for temperature
slice_icons=(󰪞 󰪟 󰪠 󰪡 󰪢 󰪣 󰪤 󰪥)
therm_icons=(󱃃 󰔏 󱃂)

cpu_prev_total=0
cpu_prev_idle=0

mod_cpu() {
  local u n s id io irq sirq st total idle dt di pct
  read -r _ u n s id io irq sirq st _ </proc/stat
  total=$((u + n + s + id + io + irq + sirq + st))
  idle=$((id + io))
  dt=$((total - cpu_prev_total))
  di=$((idle - cpu_prev_idle))
  cpu_prev_total=$total
  cpu_prev_idle=$idle
  pct=0
  ((dt > 0)) && pct=$(((dt - di) * 100 / dt))
  cpu=""
  cpu_c=""
  ((pct >= CPU_SHOW)) || return
  level "$pct" "${slice_icons[@]}"
  printf -v cpu '[%s %3d%%]' "$REPLY" "$pct"
  heat "$pct"
  cpu_ic=$REPLY
  ((pct >= LOAD_CRIT)) && cpu_c=$RED
}

mod_ram() {
  local k v total=0 avail=0 stot=0 sfree=0 pct spct
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
  ((total)) || return
  pct=$(((total - avail) * 100 / total))
  ram=""
  ram_c=""
  ((pct >= RAM_SHOW)) || return
  level "$pct" "${slice_icons[@]}"
  printf -v ram '[%s %3d%%' "$REPLY" "$pct"
  heat "$pct"
  ram_ic=$REPLY
  if ((stot)); then
    spct=$(((stot - sfree) * 100 / stot))
    ((spct > 0)) && ram+=" sw $spct%"
  fi
  ram+="]"
  ((pct >= LOAD_CRIT)) && ram_c=$RED
}

mod_temp() {
  local t
  temp=""
  temp_c=""
  [[ -r $temp_f ]] && read -r t <"$temp_f" || return
  t=$((t / 1000))
  ((t >= TEMP_SHOW)) || return
  level $(((t - 30) * 100 / 70)) "${therm_icons[@]}"
  printf -v temp '[%s %2d]' "$REPLY" "$t"
  heat "$t" "$TEMP_WARN" "$TEMP_CRIT"
  temp_ic=$REPLY
  ((t >= TEMP_CRIT)) && temp_c=$RED
}

mod_disk() {
  local out target pct label seen=" " max=0
  disk=""
  disk_c=""
  out=$(df --output=target,pcent / "$HOME" 2>/dev/null)
  while read -r target pct; do
    pct=${pct%\%}
    [[ $pct =~ ^[0-9]+$ ]] || continue # skip the header line
    [[ $seen == *" $target "* ]] && continue # $HOME on the same filesystem as /
    seen+="$target "
    ((pct >= DISK_SHOW)) || continue
    label=$target
    [[ $target == "$HOME" ]] && label="~"
    level "$pct" "${slice_icons[@]}"
    printf -v REPLY '%s %s %3d%%' "$REPLY" "$label" "$pct"
    disk+="${disk:+ }[$REPLY]"
    ((pct > max)) && max=$pct
    ((pct >= LOAD_CRIT)) && disk_c=$RED
  done <<<"$out"
  heat "$max"
  disk_ic=$REPLY
}

#!/usr/bin/env bash
# Pop-up dashboard: system, processes, network, weather, backups, services,
# Bluetooth, displays and Taskwarrior tasks.
# Usage: dashboard.sh toggle|show|hide|city [NAME]|btdebug
#   toggle: show it if closed, hide it if open (bound to a single key)
#   show:   open a floating terminal (app_id "sway-dashboard") running `view`
#   hide:   close it
#   city:   set the weather city (NAME), or print the current one
# Inside the window: Tab/arrows/1-3 switch tabs (System, Power, Hardware, Network, Services, Tasks, Weather), c changes
# the city, q or Esc close it. It redraws every 2 s.
# Optional: task (taskwarrior), curl, jq, nmcli, wpctl, bluetoothctl, vnstat.

shopt -s extglob
export LC_NUMERIC=C
export LC_TIME=C # dates always in English
self=$(readlink -f "$0")
dir=$(dirname "$self")
APP_ID=sway-dashboard
cache=${XDG_RUNTIME_DIR:-/tmp}/dashboard

. "$dir/../lib/settings.sh" # CITY, CITIES, CITY_FILE, BACKUP_*, DASH_SERVICES

# set_city NAME: save the city and drop the cached weather
set_city() {
  mkdir -p "$(dirname "$CITY_FILE")"
  printf '%s\n' "$1" >"$CITY_FILE"
  CITY=$1
  rm -f "$cache"/weather*
}

case $1 in
toggle)
  if pgrep -f "$self view" >/dev/null; then exec "$self" hide; else exec "$self" show; fi
  ;;
show)
  # Already open: nothing to do
  pgrep -f "$self view" >/dev/null && exit 0
  if pgrep -f 'foot (-s|--server)' >/dev/null && command -v footclient >/dev/null; then
    exec footclient -E -a "$APP_ID" "$self" view
  fi
  exec foot -a "$APP_ID" "$self" view
  ;;
hide)
  swaymsg "[app_id=\"$APP_ID\"] kill" >/dev/null 2>&1
  exit 0
  ;;
city)
  if [[ -n $2 ]]; then set_city "${*:2}"; fi
  echo "$CITY"
  exit 0
  ;;
btdebug)
  # Raw Bluetooth data and what the dashboard makes of it
  . "$dir/lib.sh"
  . "$dir/sections/devices.sh"
  cache=$(mktemp -d)
  echo "--- version: $(grep -c upower_bt "$dir/sections/devices.sh") (0 = old devices.sh)  dir: $dir"
  echo "--- bluetoothctl devices Connected"; bluetoothctl devices Connected 2>&1
  for m in $(bluetoothctl devices Connected 2>/dev/null | awk '{print $2}'); do
    echo "--- bluetoothctl info $m"; bluetoothctl info "$m" 2>&1
  done
  echo "--- upower -e"; upower -e 2>&1
  for p in $(upower -e 2>/dev/null | grep -i '_dev_'); do echo "--- upower -i $p"; upower -i "$p" 2>&1; done
  echo "--- upower_bt (MAC|name|percentage)"; upower_bt
  echo "--- data_bt"; data_bt
  exit 0
  ;;
view) ;;
*)
  echo "usage: ${0##*/} toggle|show|hide|city [NAME]|btdebug" >&2
  exit 1
  ;;
esac

# --- view -------------------------------------------------------------------

mkdir -p "$cache"
rm -f "$cache"/*.run

. "$dir/lib.sh"
for f in "$dir"/sections/*.sh; do . "$f"; done

# Tabs: each one lists the sections it shows. "Weather" also has the big clock.
TAB_NAMES=(System Power Hardware Network Services Backups Tasks Weather)
TAB_SECTIONS=("system processes" "power" "hardware bluetooth displays" "network" "failed services" "backup borg" "tasks" "weather")
tab=0
COLW=56   # width of one column (text + gutter)
MARGIN=2  # blank columns between the window border and the text

cols=100

# choose_city: small menu with the favourites plus free text
choose_city() {
  local i choice name
  printf '\e[2J\e[H\n\n  %sWeather city%s  (current: %s)\n\n' "$CYN" "$R" "$CITY"
  for i in "${!CITIES[@]}"; do printf '    %d)  %s\n' $((i + 1)) "${CITIES[i]}"; done
  printf '    o)  other…\n    Esc)  cancel\n\n  > '
  read -rsn1 choice
  case $choice in
  [1-9])
    [[ -n ${CITIES[choice - 1]} ]] && set_city "${CITIES[choice - 1]}"
    ;;
  o)
    printf '\n\n  City: \e[?25h'
    read -re name
    printf '\e[?25l'
    [[ -n $name ]] && set_city "$name"
    ;;
  esac
  printf '\e[2J'
}

# tab_bar WIDE: tab names, the active one highlighted. When they do not fit in the
# window (WIDE=0) the inactive tabs are shortened to their number.
tab_bar() {
  local i bar=""
  for i in "${!TAB_NAMES[@]}"; do
    if ((i == tab)); then
      bar+=$'\e[7m'" $((i + 1)) ${TAB_NAMES[i]} ${R} "
    elif (($1)); then
      bar+="${DIMC} $((i + 1)) ${TAB_NAMES[i]} ${R} "
    else
      bar+="${DIMC} $((i + 1)) ${R}"
    fi
  done
  printf '%s' "$bar"
}

draw() {
  local out name txt k i min clk date_s now body bar
  local -a colt=() coll=() tmp secs
  local ncol

  cols=$(($(tput cols 2>/dev/null || echo 100) - 2 * MARGIN))
  ncol=$((cols / COLW))
  ((ncol < 1)) && ncol=1
  ((ncol > 3)) && ncol=3

  # Header: tab bar with the date and time, then the hints
  printf -v now '%(%H:%M:%S)T' -1
  printf -v date_s '%(%a %d %b %Y)T' -1
  local width=0 wide=1
  for name in "${TAB_NAMES[@]}"; do width=$((width + ${#name} + 5)); done
  ((width > cols)) && wide=0
  bar=$(tab_bar "$wide")
  out="${bar}"$'\n'
  out+="${DIMC}${date_s}${R} ${B}${now}${R}  ${DIMC}Tab/S-Tab/←/→/1-${#TAB_NAMES[@]}: tabs · c: city · r: refresh backups · q: close${R}"$'\n\n'

  if [[ ${TAB_NAMES[tab]} == Weather ]]; then
    clk=$(clock "$now")
    out+=$(sbs "$clk" $'\n'"${B}$(printf '%(%A, %d %B %Y)T' -1)${R}" 36)$'\n\n'
  fi

  # Distribute the tab's sections: each one goes to the shortest column
  for ((i = 0; i < ncol; i++)); do
    colt[i]=""
    coll[i]=0
  done
  read -ra secs <<<"${TAB_SECTIONS[tab]}"
  for name in "${secs[@]}"; do
    txt=$("sec_$name")
    mapfile -t tmp <<<"$txt"
    k=0
    min=${coll[0]}
    for ((i = 1; i < ncol; i++)); do
      ((coll[i] < min)) && min=${coll[i]} && k=$i
    done
    colt[k]+="$txt"$'\n\n'
    coll[k]=$((coll[k] + ${#tmp[@]} + 1))
  done
  body=${colt[0]}
  for ((i = 1; i < ncol; i++)); do body=$(sbs "$body" "${colt[i]}" $((COLW * i))); done
  out+="$body"

  # Margins; overwrite in place (no flicker): clear each line's tail, then the rest
  out=${out//$'\n'/$'\e[K\n'$(printf '%*s' "$MARGIN" '')}
  printf '\e[H\n%*s%s\e[K\e[J' "$MARGIN" '' "$out"
}

# set_tab N: switch to tab N (wraps around) and clear the screen
set_tab() {
  local n=${#TAB_NAMES[@]}
  tab=$((($1 % n + n) % n))
  printf '\e[2J'
}

trap 'printf "\e[?25h"' EXIT
printf '\e[?25l\e[2J'

while :; do
  sample_net
  draw
  key=""
  IFS= read -rsn1 -t 2 key # IFS= so Tab is not stripped as whitespace
  case $key in
  q) break ;;
  $'\e')
    # Arrow keys arrive as ESC [ C/D; a lone Esc closes the dashboard
    rest=""
    read -rsn2 -t 0.05 rest
    case $rest in
    '[C') set_tab $((tab + 1)) ;;
    '[D' | '[Z') set_tab $((tab - 1)) ;; # left arrow, Shift+Tab
    '') break ;;
    esac
    ;;
  $'\t' | l) set_tab $((tab + 1)) ;;
  h) set_tab $((tab - 1)) ;;
  [1-9]) ((key <= ${#TAB_NAMES[@]})) && set_tab $((key - 1)) ;;
  r) rm -f "$cache"/borg* ;; # drop the cached borgmatic result (e.g. after fixing ssh)
  c) choose_city ;;
  esac
done

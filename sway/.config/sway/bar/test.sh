#!/usr/bin/env bash
# Tests for the bar: syntax, module logic with fake sysfs/state, and a smoke run
# of `bar.sh --once` with stubbed commands. Usage: bar/test.sh
dir=$(dirname "$(readlink -f "$0")")
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
fail=0

check() { # check DESCRIPTION ACTUAL EXPECTED
  if [[ $2 == "$3" ]]; then
    printf 'ok    %s\n' "$1"
  else
    printf 'FAIL  %s\n      got:      %q\n      expected: %q\n' "$1" "$2" "$3"
    fail=1
  fi
}

# --- Syntax -------------------------------------------------------------
for f in "$dir"/bar.sh "$dir"/icons.sh "$dir"/modules/*.sh; do
  bash -n "$f" 2>"$tmp/err"
  check "syntax ${f#"$dir"/}" "$(<"$tmp/err")" ""
done

# --- Modules (run in a subshell so test state does not leak) -----------------
(
  export LC_NUMERIC=C
  RED=r GRN=g BLU=b YEL=y DIM=d
  notified=""
  . "$dir/../lib/settings.sh"
  . "$dir/icons.sh"
  for f in "$dir"/modules/*.sh; do . "$f"; done
  notify() { notified+="$*;"; }

  # add(): escaping and icon colouring
  blocks=""
  add t 'a&b "q"' ""
  check "add escapes & and quotes" "$blocks" '{"name":"t","full_text":" a&amp;b \"q\" ","markup":"pango","separator":false,"separator_block_width":0}'
  blocks=""
  add t "$ICON_ETH x" "" "#f00"
  [[ $blocks == *"<span foreground='#f00'>$ICON_ETH</span> x"* ]] && r=ok || r=$blocks
  check "add colours the leading icon" "$r" ok

  # level()
  level 0 a b c
  check "level 0" "$REPLY" a
  level 100 a b c
  check "level 100" "$REPLY" c

  # heat / heat_low
  heat 95
  check "heat crit" "$REPLY" "$RED"
  heat_low 20 30 15
  check "heat_low warn" "$REPLY" "$YEL"

  # mod_net from a probe line
  net_raw="1||72|enp3|Wired|no|My|SSID"
  mod_net
  check "net wifi text" "$wifi_s" "${ICON_WIFI[3]} My|SSID"
  check "net wifi info" "$wifi_info" $'My|SSID\nSignal: 72%'
  check "net eth" "$eth_s" "$ICON_ETH"
  net_raw="||0|usb0|Phone|yes|"
  mod_net
  check "net tethering" "$phone_s/$eth_s" "$ICON_PHONE/"
  net_raw="|1|0|||"
  mod_net
  check "net wifi off" "$wifi_s" "$ICON_WIFI_OFF"

  # Battery: time left / until full, full notice
  d=$tmp/bat
  mkdir "$d"
  echo 50 >"$d/capacity"
  echo Charging >"$d/status"
  echo 50000000 >"$d/energy_now"
  echo 100000000 >"$d/energy_full"
  echo 25000000 >"$d/power_now"
  bat=("$d")
  mod_battery
  check "battery until full" "$battery_info" "Charging, 50%, 2h00m until full"
  echo Discharging >"$d/status"
  mod_battery
  check "battery time left" "$battery_info" "Discharging, 50%, 2h00m left"
  echo "Not charging" >"$d/status"
  mod_battery
  check "battery plug icon" "${battery%% *}" "$ICON_BAT_PLUG"
  echo 99 >"$d/capacity"
  echo Charging >"$d/status"
  mod_battery
  echo 100 >"$d/capacity"
  echo Full >"$d/status"
  notified=""
  mod_battery
  check "battery full notice" "$notified" "Battery full You can unplug the charger;"

  # Brightness
  d=$tmp/bl
  mkdir "$d"
  echo 50 >"$d/brightness"
  echo 200 >"$d/max_brightness"
  backlights=("$d")
  mod_bright
  check "brightness" "$bright" "${ICON_BRIGHT[0]}"

  # Layout icons
  layout_raw="tabbed|splitv"
  mod_layout
  check "layout tabbed + split" "$layout" "$ICON_LAYOUT_TABS $ICON_LAYOUT_SPLITV"
  layout_raw="splith|splith"
  mod_layout
  check "layout splith" "$layout" "$ICON_LAYOUT_SPLITH"
  layout_raw="none|"
  mod_layout
  check "layout none" "$layout" ""

  # layout_probe against a fake tree: tabbed inside a vertical split
  swaymsg() {
    echo '{"layout":"splith","nodes":[{"layout":"output","nodes":[{"layout":"splitv","nodes":[{"layout":"tabbed","nodes":[{"layout":"none","focused":false,"nodes":[]},{"layout":"none","focused":true,"nodes":[]}]}]}]}]}'
  }
  check "layout_probe" "$(layout_probe)" "tabbed|splitv"
  unset -f swaymsg

  # Temperature notice fires once
  t_file=$tmp/temp
  temp_f=$t_file
  echo 90000 >"$t_file"
  notified=""
  mod_temp
  mod_temp
  check "temp notice once" "$notified" "-u critical High temperature CPU at 90°C;"

  # Failed units: first check is silent, a new unit notifies
  systemctl() { [[ $1 == --user ]] || printf '%s\n' "${FAILED_UNITS:-}"; }
  FAILED_UNITS=""
  notified=""
  mod_failed
  FAILED_UNITS="foo.service loaded failed failed Foo"
  mod_failed
  check "failed unit notice" "$notified" "-u critical Unit failed foo.service;"
  mod_failed
  check "failed unit not repeated" "$notified" "-u critical Unit failed foo.service;"

  # Governor
  prof_file=$tmp/profile
  echo balanced >"$prof_file"
  gov_name
  check "gov balanced" "$REPLY" balanced
) || fail=1

# --- Smoke test: bar.sh --once with stubbed commands -------------------------
stubs=$tmp/stubs
mkdir "$stubs"
stub() { printf '#!/bin/sh\n%s\n' "$2" >"$stubs/$1" && chmod +x "$stubs/$1"; }
stub swaymsg 'case "$*" in *subscribe*) exit 0 ;; *get_inputs*) echo "[{\"type\":\"keyboard\",\"xkb_active_layout_name\":\"English (US)\",\"xkb_layout_names\":[\"English (US)\",\"Spanish\"]}]" ;; *) echo "{\"nodes\":[]}" ;; esac'
stub nmcli 'case "$*" in *monitor*) sleep 1 ;; *"connection show"*) echo "Home:802-11-wireless:wlan0" ;; *"wifi list"*) echo "*:Home:80" ;; esac'
stub wpctl 'echo "Volume: 0.40"'
stub makoctl 'echo default'
out=$(PATH="$stubs:$PATH" XDG_RUNTIME_DIR=$tmp timeout 30 bash "$dir/bar.sh" --once 2>"$tmp/bar.err")
check "smoke: exit status" "$?" 0
check "smoke: valid JSON" "$(sed 's/,$//' <<<"$out" | jq -e 'length > 0' 2>&1)" true
check "smoke: wifi block" "$([[ $out == *'"name":"wifi"'*Home* ]] && echo yes)" yes
check "smoke: volume block" "$([[ $out == *'"name":"vol"'*40%* ]] && echo yes)" yes
check "smoke: keyboard block" "$([[ $out == *'"name":"kbd"'* ]] && echo yes)" yes
check "smoke: no errors logged" "$(<"$tmp/bar.log")" ""

# --- Clicks: swaybar writes JSON with spaces after the colons ---------------
stub notify-send 'echo "$*" >>"$XDG_RUNTIME_DIR/calls"'
(
  sleep 2
  echo '['
  echo '{ "name": "battery", "button": 1, "x": 5 },'
  sleep 2
) | PATH="$stubs:$PATH" XDG_RUNTIME_DIR=$tmp timeout 5 bash "$dir/bar.sh" >/dev/null 2>&1
check "click: battery notification" "$(grep -c '^-e Battery' "$tmp/calls" 2>/dev/null)" 1

exit $fail

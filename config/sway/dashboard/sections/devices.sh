#!/usr/bin/env bash
# Bluetooth devices and displays sections (sourced by dashboard.sh).

# bt_line NAME PCT [WHY]: one device line, name cut so the gauge never spills into
# the next column. WHY says which source had nothing when there is no percentage.
bt_line() {
  printf '%s%-24.24s%s ' "$GRN" "$1" "$R"
  if [[ $2 =~ ^[0-9]+$ ]]; then bat_gauge "$2"; else printf '%sno battery info%s%s' "$DIMC" "${3:+ ($3)}" "$R"; fi
  echo
}

# upower_bt: "MAC|name|percentage" for every Bluetooth device upower knows about
# (paths look like .../headset_dev_AA_BB_CC_DD_EE_FF). upower is the most reliable
# battery source: it reads the same BlueZ data and also covers HID power_supply.
upower_bt() {
  local p out
  command -v upower >/dev/null || return
  for p in $(upower -e 2>/dev/null | grep -i '_dev_'); do
    out=$(upower -i "$p" 2>/dev/null)
    awk -v path="$p" '
      /^ *model:/ {sub(/^ *model: */, ""); name = $0}
      /^ *serial:/ {mac = $2}
      /^ *percentage:/ {gsub(/[^0-9]/, "", $2); pct = $2}
      END {
        if (mac == "") {n = split(path, a, "dev_"); mac = toupper(a[n]); gsub(/_/, ":", mac)}
        print toupper(mac) "|" (name == "" ? mac : name) "|" pct
      }' <<<"$out"
  done
}

data_bt() {
  local mac name line pct why connected powered="" row u_mac u_name u_pct n=0
  local -A seen=() ubat=()

  # Batteries from upower, keyed by MAC
  while IFS='|' read -r u_mac u_name u_pct; do
    [[ -n $u_mac ]] || continue
    ubat[$u_mac]=$u_pct
  done < <(upower_bt)

  if command -v bluetoothctl >/dev/null; then
    powered=$(bluetoothctl show 2>/dev/null | awk '/Powered:/ {print $2}')
    if [[ $powered == no ]]; then
      printf 'Adapter   %soff%s\n' "$DIMC" "$R"
      return
    fi
    while read -r _ mac name; do
      [[ -n $mac ]] || continue
      seen[${mac^^}]=1
      pct=""
      connected=0
      while read -r line; do
        [[ $line == *"Connected: yes"* ]] && connected=1
        # "Battery Percentage: 0x5a (90)"; take the digits inside the parentheses
        # (the line may carry a trailing \r or colour codes, so no suffix trimming)
        [[ $line == *"Battery Percentage"* && $line =~ \(([0-9]+)\) ]] && pct=${BASH_REMATCH[1]}
      done < <(bluetoothctl info "$mac" 2>/dev/null)
      ((connected)) || continue
      [[ $pct =~ ^[0-9]+$ ]] || pct=""
      # bluetoothctl first, then upower, then the kernel power_supply entry (HID)
      [[ -n $pct ]] || pct=${ubat[${mac^^}]}
      if [[ -z $pct ]]; then
        for line in /sys/class/power_supply/*"${mac//:/_}"* /sys/class/power_supply/hid-"${mac,,}"-battery; do
          [[ -r $line/capacity ]] && read -r pct <"$line/capacity" && break
        done
      fi
      why=""
      if [[ -z $pct ]]; then
        if ! command -v upower >/dev/null; then why="upower not installed"
        elif [[ -z ${ubat[${mac^^}]+x} ]]; then why="upower does not list ${mac^^}"
        else why="upower has no percentage"; fi
      fi
      bt_line "$name" "$pct" "$why"
      n=$((n + 1))
    done < <(bluetoothctl devices 2>/dev/null)
  fi

  # Devices upower reports that bluetoothctl did not list (or bluetoothctl missing)
  while IFS='|' read -r u_mac u_name u_pct; do
    [[ -n $u_mac && -z ${seen[$u_mac]} ]] || continue
    bt_line "$u_name" "$u_pct" "upower has no percentage"
    n=$((n + 1))
  done < <(upower_bt)

  if ((n == 0)); then
    if [[ -z $powered ]] && ! command -v upower >/dev/null; then
      printf '%sneither bluetoothctl nor upower installed%s\n' "$DIMC" "$R"
    else
      printf 'Adapter   on, no device connected\n'
    fi
  fi
}

data_displays() {
  command -v swaymsg >/dev/null || return
  swaymsg -t get_outputs 2>/dev/null | jq -r '.[] | select(.active) | "\(.name)  \(.current_mode.width)x\(.current_mode.height)@\((.current_mode.refresh / 1000) | round)Hz  x\(.scale)"'
  pgrep -x wl-mirror >/dev/null && printf '%smirroring on%s\n' "$YEL" "$R"
}

sec_bluetooth() {
  title "Bluetooth"
  cached bluetooth 10 data_bt
}

sec_displays() {
  title "Displays"
  cached displays 10 data_displays
}

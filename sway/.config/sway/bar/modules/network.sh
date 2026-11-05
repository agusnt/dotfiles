#!/usr/bin/env bash
# Network modules (sourced by ../bar.sh)
#
# net_probe runs in a background process (net_loop, started by bar.sh) and
# prints one line whenever NetworkManager reports a change (nmcli monitor) or
# every 10 s (signal strength). mod_net parses the latest line in the bar
# process, so a slow nmcli never blocks the main loop.

# Metered state of the wired device, cached per connection (it only changes
# when the connection does). Only used inside net_probe.
declare -A metered_cache

# One line: wifi|has_wlan|signal|eth_dev|eth_name|metered|ssid
net_probe() {
  local out name type dev wifi="" eth_dev="" eth_name="" m="" line ssid="" sig=0 has_wlan=""
  out=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active 2>/dev/null)
  while IFS=: read -r name type dev; do
    case $type in
    802-11-wireless) wifi=1 ;;
    802-3-ethernet)
      eth_dev=$dev
      eth_name=$name
      ;;
    esac
  done <<<"$out"

  if [[ -n $wifi ]]; then
    # Real SSID of the network in use (not the connection name)
    out=$(nmcli -t -f IN-USE,SSID,SIGNAL device wifi list --rescan no 2>/dev/null)
    while read -r line; do
      [[ $line == '*:'* ]] && {
        sig=${line##*:}
        ssid=${line#*:}
        ssid=${ssid%:*}
        ssid=${ssid//\\:/:}
        break
      }
    done <<<"$out"
  else
    compgen -G '/sys/class/net/*/wireless' >/dev/null && has_wlan=1
  fi

  if [[ -n $eth_dev ]]; then
    m=${metered_cache[$eth_name:$eth_dev]}
    if [[ -z $m ]]; then
      m=$(nmcli -t -g GENERAL.METERED device show "$eth_dev" 2>/dev/null)
      metered_cache[$eth_name:$eth_dev]=${m:-no}
      m=${m:-no}
    fi
  fi
  printf '%s|%s|%s|%s|%s|%s|%s\n' "$wifi" "$has_wlan" "${sig:-0}" "$eth_dev" "$eth_name" "$m" "$ssid"
}

# Probe on every NetworkManager event. If nmcli monitor exits, poll every 10 s
# for a minute and then start it again.
net_loop() {
  local mon_fd rc i
  trap '[[ -n $mon_pid ]] && kill "$mon_pid" 2>/dev/null' EXIT
  while :; do
    net_probe
    exec {mon_fd}< <(exec nmcli monitor 2>/dev/null)
    mon_pid=$!
    while :; do
      read -r -t 10 -u "$mon_fd" _
      rc=$?
      ((rc == 1)) && break # monitor exited
      while read -r -t 0.5 -u "$mon_fd" _; do :; done # one probe per burst of events
      net_probe
    done
    exec {mon_fd}<&-
    kill "$mon_pid" 2>/dev/null
    for ((i = 0; i < 6; i++)); do
      sleep 10
      net_probe
    done
  done
}

mod_net() {
  local wifi has_wlan sig eth_dev eth_name m ssid
  [[ -n $net_raw ]] || return
  IFS='|' read -r wifi has_wlan sig eth_dev eth_name m ssid <<<"$net_raw"

  wifi_s=""
  wifi_c=""
  wifi_ic=""
  wifi_info="WiFi disconnected"
  eth_s=""
  eth_c=""
  eth_ic=""
  phone_s=""
  phone_c=""
  phone_ic=""
  if [[ -n $wifi ]]; then
    level "$sig" "${ICON_WIFI[@]}"
    wifi_s="$REPLY $ssid"
    wifi_info="$ssid"$'\n'"Signal: $sig%"
    heat_low "$sig" "$SIG_WARN" "$SIG_CRIT"
    wifi_ic=$REPLY
  elif [[ -n $has_wlan ]]; then
    # Hidden on machines without a WiFi adapter
    wifi_s=$ICON_WIFI_OFF
    wifi_c=$RED
  fi
  if [[ -n $eth_dev ]]; then
    if [[ $m == yes* ]]; then
      phone_s=$ICON_PHONE
    else
      eth_s=$ICON_ETH
    fi
  fi

  # Notify when a link goes down or comes back
  track wifi "${wifi:+up}"
  ((REPLY)) && { [[ -n $wifi ]] && notify "WiFi" "Connected to $ssid" || notify "WiFi" "Disconnected"; }
  track eth "${eth_s:+up}"
  ((REPLY)) && { [[ -n $eth_s ]] && notify "Ethernet" "Connected" || notify "Ethernet" "Disconnected"; }
  track phone "${phone_s:+up}"
  ((REPLY)) && { [[ -n $phone_s ]] && notify "Phone tethering" "Connected" || notify "Phone tethering" "Disconnected"; }
}

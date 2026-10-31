#!/usr/bin/env bash
# Network modules (sourced by ../bar.sh)

# Metered state of the wired device, cached per connection (it only changes
# when the connection does)
declare -A metered_cache

mod_net() {
  local out name type dev wifi="" eth_dev="" eth_name="" m line ssid="" sig=0
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

  wifi_c=$RED
  eth_c=""
  phone_c=""
  eth_ic=""
  phone_ic=""
  wifi_ic=""
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
    level "${sig:-0}" 󰤯 󰤟 󰤢 󰤥 󰤨
    wifi_s="[$REPLY $ssid]"
    wifi_c=""
    heat_low "${sig:-0}" "$SIG_WARN" "$SIG_CRIT"
    wifi_ic=$REPLY
  else
    # Hidden on machines without a WiFi adapter
    wifi_s=""
    wifi_c=""
    compgen -G '/sys/class/net/*/wireless' >/dev/null && wifi_s="[󰖪]"
  fi
  eth_s=""
  phone_s=""
  if [[ -n $eth_dev ]]; then
    m=${metered_cache[$eth_name:$eth_dev]}
    if [[ -z $m ]]; then
      m=$(nmcli -t -g GENERAL.METERED device show "$eth_dev" 2>/dev/null)
      metered_cache[$eth_name:$eth_dev]=${m:-no}
    fi
    if [[ $m == yes* ]]; then
      phone_s="[]"
    else
      eth_s="[󰈀]"
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

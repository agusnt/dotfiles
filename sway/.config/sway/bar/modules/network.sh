#!/usr/bin/env bash
# Network modules (sourced by ../bar.sh)

net_if=""
net_rx=-1
net_tx=0

# Default-route interface; counters are only reset when it changes
mod_netif() {
  local ifn dest new=""
  while read -r ifn dest _; do
    [[ $dest == 00000000 ]] && {
      new=$ifn
      break
    }
  done </proc/net/route
  if [[ $new != "$net_if" ]]; then
    net_if=$new
    net_rx=-1
  fi
}

# Arrow icon + colour by throughput: dimmed when idle, normal when active,
# fast double arrow in green from 1 MB/s. Sets $REPLY (icon) and $net_c (colour).
net_arrow() {
  local b=$1 low=$2 high=$3
  if ((b >= 1048576)); then
    REPLY=$high
    net_c=$GRN
  elif ((b >= 1024)); then
    REPLY=$low
    net_c=""
  else
    REPLY=$low
    net_c=$DIM
  fi
}

# Network speed: called every second; rx and tx are separate blocks so each
# arrow can show its own activity level
mod_netspeed() {
  local rx tx d u=0 dn=0
  if [[ -n $net_if && -r /sys/class/net/$net_if/statistics/rx_bytes ]]; then
    read -r rx <"/sys/class/net/$net_if/statistics/rx_bytes"
    read -r tx <"/sys/class/net/$net_if/statistics/tx_bytes"
    if ((net_rx >= 0)); then
      dn=$((rx - net_rx))
      u=$((tx - net_tx))
    fi
    net_rx=$rx
    net_tx=$tx
  fi
  ((dn < 0)) && dn=0
  ((u < 0)) && u=0
  hr $dn
  d=$REPLY
  hr $u
  u_txt=$REPLY
  net_arrow $dn 󰁅 
  netrx="[$REPLY $d]"
  netrx_c=$net_c
  net_arrow $u 󰁝 
  nettx="[$REPLY $u_txt]"
  nettx_c=$net_c
}

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

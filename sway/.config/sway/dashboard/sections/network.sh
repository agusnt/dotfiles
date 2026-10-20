#!/usr/bin/env bash
# Network section (sourced by dashboard.sh).

net_if=""
rx_rate=""
tx_rate=""
prev_rx=""
prev_tx=""
prev_t=0
prev_if=""

# sample_net: called by the main loop (not in a subshell) to keep rate state
sample_net() {
  local ifn dest rx tx now dt
  net_if=""
  while read -r ifn dest _; do
    [[ $dest == 00000000 ]] && {
      net_if=$ifn
      break
    }
  done </proc/net/route
  rx_rate=""
  [[ -n $net_if && -r /sys/class/net/$net_if/statistics/rx_bytes ]] || return
  read -r rx <"/sys/class/net/$net_if/statistics/rx_bytes"
  read -r tx <"/sys/class/net/$net_if/statistics/tx_bytes"
  now=${EPOCHREALTIME/./}
  dt=$((now - prev_t))
  if [[ $prev_if == "$net_if" && -n $prev_rx ]] && ((dt > 0)); then
    rx_rate=$(((rx - prev_rx) * 1000000 / dt))
    tx_rate=$(((tx - prev_tx) * 1000000 / dt))
  fi
  prev_rx=$rx
  prev_tx=$tx
  prev_t=$now
  prev_if=$net_if
}

data_net() {
  local ifn="" dest ip="" ssid="" line
  while read -r ifn dest _; do
    [[ $dest == 00000000 ]] && break
    ifn=""
  done </proc/net/route
  if [[ -z $ifn ]]; then
    printf 'Link      %soffline%s\n' "$RED" "$R"
  else
    read -r _ _ _ ip _ < <(ip -4 -o addr show dev "$ifn" 2>/dev/null)
    while read -r line; do
      [[ $line == '*:'* ]] && {
        ssid=${line#*:}
        break
      }
    done < <(nmcli -t -f IN-USE,SSID device wifi list --rescan no 2>/dev/null)
    printf 'Link      %s  %s%s\n' "$ifn" "${ip%/*}" "${ssid:+  ($ssid)}"
  fi
  if [[ -e /sys/class/net/nas ]]; then
    printf 'VPN       %sup%s\n' "$GRN" "$R"
  else
    printf 'VPN       %sdown%s\n' "$RED" "$R"
  fi
}

# Traffic of the default interface: today with vnstat, else since boot
data_traffic() {
  local f rx tx
  [[ -n $net_if ]] || return
  if command -v vnstat >/dev/null && IFS=';' read -ra f < <(vnstat -i "$net_if" --oneline 2>/dev/null) && [[ -n ${f[4]} ]]; then
    printf 'Today     ↓ %s  ↑ %s\n' "${f[3]}" "${f[4]}"
  else
    read -r rx <"/sys/class/net/$net_if/statistics/rx_bytes"
    read -r tx <"/sys/class/net/$net_if/statistics/tx_bytes"
    bytes_h "$rx"
    printf 'Boot      ↓ %s' "$REPLY"
    bytes_h "$tx"
    printf '  ↑ %s\n' "$REPLY"
  fi
}

sec_network() {
  title "Network"
  cached net 10 data_net
  if [[ -n $rx_rate ]]; then
    bytes_h "$rx_rate"
    printf 'Speed     ↓ %s/s' "$REPLY"
    bytes_h "$tx_rate"
    printf '  ↑ %s/s\n' "$REPLY"
  fi
  cached traffic 30 data_traffic
}

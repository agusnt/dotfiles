#!/usr/bin/env bash

get_backup() {
  FILE="/tmp/backups"
  if [ ! -f $FILE ]; then
    touch $FILE
    sudo borgmatic list --repository ssh://nas/mnt/storage/backups/laptop | awk 'END {print $3, "("NR-1")"}' >$FILE &
    echo -n ""
  fi

  info=$(tail -n1 $FILE)
  if [ -n "$info" ]; then
    echo -n "[󰁯 $info]"
  else
    echo -n ""
  fi
}

get_updates_gentoo() {
  FILE="/tmp/updates.gentoo"
  if [ ! -f $FILE ]; then
    return 0
  fi

  val=$(cat $FILE)
  if [ -n "$val" ] && [ "$val" -ne 0 ]; then echo "󰏕 $val "; fi
}

get_temp_status() {
  echo -n "[ $(awk '{printf "%d\n", $1/1000}' /sys/class/thermal/thermal_zone0/temp)]"
}

get_cpu_status() {
  echo -n "[ $(awk '{print $1}' /proc/loadavg)]"
}

get_ram_status() {
  echo -n "[ $(free | grep Mem | awk '{printf "%d\n", $3/$2 * 100}')%]"
}

get_data_status() {
  echo -n "[$(get_updates_gentoo)$(get_borgmatic_status)$(get_wireguard_status)]"
}

get_borgmatic_status() {
  if ps aux | pgrep borgmatic >/dev/null 2>&1; then
    echo -n "󰸧 "
  fi
}

get_keyboard_layout() {
  layout=$(swaymsg -t get_inputs | jq '.[] | select(.type == "keyboard") | .xkb_active_layout_name' | head -n1 | tr -d '"')

  case $layout in
  *US*)
    echo -n "[us]"
    ;;
  *Spanish*)
    echo -n "[en]"
    ;;
  *) ;;
  esac
}

get_wireguard_status() {
  if nmcli -t -f NAME connection show --active | grep -q "wg0"; then
    echo -n "󰦝"
  else
    echo -n "󰦜"
  fi
}

get_wifi_status() {
  SSID=$(nmcli -t connection show --active | grep "802-11-wireless" | cut -d':' -f1)

  if [ -z "$SSID" ]; then
    echo -n "󰖪"
  else
    echo -n "󰖩 $SSID"
  fi
}

get_smartphone_status() {
  DEVICE=$(nmcli -t connection show --active | grep "802-3-ethernet" | rev | cut -d':' -f1 | rev)
  if [ -n "$DEVICE" ]; then
    if nmcli -t -f GENERAL.METERED device show "$DEVICE" | grep -q "yes"; then
      echo -n ""
      return 0
    fi
  fi
  echo -n "󱘖"
}

get_eth_status() {
  DEVICE=$(nmcli -t connection show --active | grep "802-3-ethernet" | rev | cut -d':' -f1 | rev)
  if [ -n "$DEVICE" ]; then
    if nmcli -t -f GENERAL.METERED device show "$DEVICE" | grep -v -q "yes"; then
      echo -n "󰈀"
      return 0
    fi
  fi
  echo -n "󰈂"
}

get_internet_status() {
  echo -n "[$(get_wifi_status) $(get_eth_status) $(get_smartphone_status)]"
}

get_vol_status() {
  VOL=$(wpctl get-volume @DEFAULT_SINK@ | cut -d' ' -f 2 | cut -d'.' -f2)
  if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"; then
    echo -n "[󰖁"
  else
    echo -n "[󱄠"
  fi
  if pactl get-default-sink | grep -q -i "bluez\|bluetooth"; then
    echo -n " 󰂱"
  fi
  echo -n " $VOL%]"
}

get_bright_status() {
  PER=$(echo "scale=2; ($(brightnessctl g) / $(brightnessctl m)) * 100" | bc -l | cut -d'.' -f1)
  echo -n "[󰃠 $PER%]"
}

get_battery_status() {
  CAPACITY=$(cat "/sys/class/power_supply/BAT0/capacity")
  TIME="$(upower -i "$(upower -e | grep 'BAT')" | grep "time to empty" | awk '{print $4, $5}')"
  [ -z "$TIME" ] && TIME="$(upower -i "$(upower -e | grep 'BAT')" | grep "time to full" | awk '{print $4 $5}')"
  [ -n "$TIME" ] && TIME=" $TIME"

  echo -n "[󰁹 $CAPACITY%$TIME]"
}

get_date_status() {
  echo -n "[$(date +'%A, %d de %B del %Y, %H:%M')]"
}

while true; do
  echo "$(get_cpu_status) $(get_ram_status) $(get_temp_status) $(get_vol_status) $(get_bright_status) $(get_data_status) $(get_internet_status) $(get_battery_status) $(get_keyboard_layout) $(get_date_status)"
  sleep 1
done

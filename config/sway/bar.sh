#!/usr/bin/env bash
WIFI_DEVICE="wlan0"
ETH_DEVICE="eth0"
SMT_DEVICE="enp197s0f0u2"


get_temp_status() {
  echo -n "[ $(awk '{printf "%d\n", $1/1000}' /sys/class/thermal/thermal_zone0/temp)]"
}

get_cpu_status() {
  echo -n "[ $(top -bn2 -d 0.01 | grep "Cpu(s)" | tail -n1 | awk '{printf "%d\n", 100 - $8}')%]"
}

get_ram_status() {
  echo -n "[ $(free | grep Mem | awk '{printf "%d\n", $3/$2 * 100}')%]"
}

get_wireguard_status() {
  if [ ! -z "$(sudo wg)" ]; then
    echo -n "[󰦝]"
  else
    echo -n "[󰦜]"
  fi
}

get_wifi_status() {
  SIGNAL=$(iw dev $WIFI_DEVICE link | grep signal | awk '{print $2}')
  if [ -z "$SIGNAL" ]; then
    echo -n "[󰖪]"
  else
    SSID=$(iw dev $WIFI_DEVICE link | grep SSID | awk '{print $2}')
    if [ "$SIGNAL" -le -100 ]; then QUALITY=0;
    elif [ "$SIGNAL" -ge -50 ]; then QUALITY=100;
    else QUALITY=$(( (SIGNAL + 100) * 2 )); fi
    
    echo -n "[󰖩 $SSID $QUALITY%]"
  fi
}

get_smartphone_status() {
  if [[ "$(cat /sys/class/net/$SMT_DEVICE/operstate 2>/dev/null)" == "up" ]]; then
    echo -n "[]"
  else
    echo -n "[󱘖]"
  fi
}

get_eth_status() {
  if [[ "$(cat /sys/class/net/$ETH_DEVICE/operstate 2>/dev/null)" == "up" ]]; then
    echo -n "[󰈀]"
  else
    echo -n "[󰈂]"
  fi
}

get_vol_status() {
  VOL=$(wpctl get-volume @DEFAULT_SINK@ | cut -d' ' -f 2 | cut -d'.' -f2)
  if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"; then
    echo -n "["
  else
    echo -n "["
  fi
  echo -n " $VOL%]"
}

get_bright_status() {
  PER=$(echo "scale=2; ($(brightnessctl g) / $(brightnessctl m)) * 100" | bc -l | cut -d'.' -f1)
  echo -n "[󰃠 $PER%]"
}

get_battery_status() {
  BAT=$(ls /sys/class/power_supply/ | grep BAT | head -n 1)
  if [ ! -z "$BAT" ]; then
    CAPACITY=$(cat "/sys/class/power_supply/$BAT/capacity")
    TIME_EMPTY=" $(upower -i $(upower -e | grep 'BAT') | grep "time to empty" | awk '{print $4, $5}')"
    if [[ "$TIME_EMPTY" == " " ]]; then
      TIME_EMPTY=""
    fi

    echo -n "[󰁹 $CAPACITY%$TIME_EMPTY]"
  fi
}

get_date_status() {
  echo -n "[$(date +'%A, %d de %B del %Y, %H:%M')]"
}

while true; do
  echo "$(get_cpu_status) $(get_ram_status) $(get_temp_status) $(get_vol_status) $(get_bright_status) $(get_wireguard_status) $(get_wifi_status) $(get_eth_status) $(get_smartphone_status) $(get_battery_status) $(get_date_status)"
  sleep 1
done

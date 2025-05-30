fn_vol() {
  # Volumen control
  muted=$(pactl get-sink-mute @DEFAULT_SINK@ | cut -d' ' -f2)
  volume=$(pactl get-sink-volume @DEFAULT_SINK@ | head -n1 | cut -d'/' -f2 | cut -d'%' -f1 | tr -d ' ')

  if [ "$muted" = "yes" ]; then
    vol="󰖁 "
  else
    if [ $volume -lt 33 ]; then
      vol="󰕿 ($volume%)"
    elif [ $volume -lt 66 ]; then
      vol="󰖀 ($volume%)"
    else
      vol="󰕾 ($volume%)"
    fi
  fi
  echo "$vol"
}

fn_network() {
  # Ntwork interface
  IFACE=eno1
  if ip address | grep $IFACE | grep -q UP; then
    IP=$(ip address | grep $IFACE | grep inet | awk '{print $2}')
    echo "󰈀  $IP"
  else
    echo "󱘖 "
  fi
}

fn_bright() {
  level=$(brightnessctl | grep "%" | cut -d'(' -f2 | cut -d'%' -f1)
  echo "$level" >/tmp/bright.level
  if [ $level -lt 33 ]; then
    echo "󰃞 ($level%)"
  elif [ $level -lt 66 ]; then
    echo "󰃝 ($level%)"
  else
    echo "󰃠 "
  fi
}

fn_bat() {
  state=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state" | awk '{print $2}')
  per=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "percentage" | awk '{print $2}' | cut -d'%' -f1)
  time=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "time to" | awk -F':' '/,/{gsub(/ /, "", $2);print $2}')
  if [ -n "$time" ]; then
    time=$(echo ", $time" | xargs)
  fi
  if [ "$state" = "discharging" ]; then
    if [ $per -lt 5 ]; then
      bat="󰂃"
    elif [ $per -lt 10 ]; then
      bat="󰁺"
    elif [ $per -lt 20 ]; then
      bat="󰁻"
    elif [ $per -lt 30 ]; then
      bat="󰁼"
    elif [ $per -lt 40 ]; then
      bat="󰁽"
    elif [ $per -lt 50 ]; then
      bat="󰁾"
    elif [ $per -lt 60 ]; then
      bat="󰁿"
    elif [ $per -lt 70 ]; then
      bat="󰂀"
    elif [ $per -lt 80 ]; then
      bat="󰂁"
    elif [ $per -lt 90 ]; then
      bat="󰂂"
    else
      bat="󰁹"
    fi
    echo "$bat ($per%$time)"
  else
    echo "󰂄 ($per%$time)"
  fi
}

fn_music() {
  # Music
  player="playerctl --player=spotify"
  statusMusic=$($player status | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  if [ "$statusMusic" = "Playing" ]; then
    status="󰎇"
  else
    echo "󰎊"
    return
  fi

  # Title and artist
  title=$($player metadata xesam:title)
  artist=$($player metadata xesam:artist)

  position=$($player position)
  duration=$(($($player metadata mpris:length) / 1000000))
  posRelative=$(echo "($position / $duration) * 100" | bc -l | cut -d'.' -f1)

  # Bar for the position
  bar=""
  for i in 0 10 20 30 40 50 60 70 80 90; do
    if [ "$posRelative" -gt $i ]; then
      bar="$bar"
    else
      bar="$bar"
    fi
  done

  if [ "$posRelative" -gt 90 ]; then
    bar="$bar"
  else
    bar="$bar"
  fi

  echo "$status $title $bar $artist"
}

fn_dnd() {
  if [ "$(makoctl mode)" = "dnd" ]; then
    echo -n " [󱏨]"
  fi
  echo -n " "
}

show_date=$(date '+%a, %d/%m/%y, %H:%M')

echo ["$(cat /tmp/weather)"] ["$(fn_music)"] ["$(fn_vol)"] ["$(fn_network)"]"$(fn_dnd)"["$show_date"]
#echo ["$(cat /tmp/weather)"] ["$(fn_music)"] ["$(fn_bright)"] ["$(fn_bat)"] ["$(fn_vol)"] ["$(fn_network)"] ["$show_date"]

#!/usr/bin/bash

# There is no music

if ! playerctl status >/dev/null 2>/dev/null; then
  if [[ "$(cat /tmp/music-title)" != "None" ]]; then
    echo "None" >/tmp/music-title
    echo "None" >/tmp/music-artist
    echo "0" >/tmp/music-pos
    echo ""
  fi
  exit
fi

# Get information about what is currently playing
last_title=$(cat /tmp/music-title)
playerctl metadata xesam:title >/tmp/music-title
playerctl metadata xesam:artist >/tmp/music-artist

# Get music position
position=$(playerctl position)
duration=$(($(playerctl metadata mpris:length) / 1000000))
posRelative=$(echo "($position / $duration) * 100" | bc -l)
printf "%.0f\n" "$posRelative" >/tmp/music-pos

# Get Actual state
statusMusic=$(playerctl status | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
if [[ "$statusMusic" == 'Playing' ]]; then
  echo "󰏤" >/tmp/music-stat
else
  echo "" >/tmp/music-stat
fi

# Download the art only if the song change
new_title=$(cat /tmp/music-title)
if [[ "$last_title" != "$new_title" ]]; then
  # Check if there is internet
  if ! wget -q --spider http://google.com; then
    # There is not internet, default art
    eww update music-image="~/.config/eww/images/no_music.jpg"
    exit
  fi
  # There is internet download it
  curl -o /tmp/music-artist.jpg "$(playerctl metadata mpris:artUrl)" 2>/dev/null
  eww update music-image="/tmp/music-artist.jpg"
fi

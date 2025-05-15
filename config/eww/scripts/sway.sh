#!/bin/bash

declare -A icons
declare -A returnM
icons=(
  ["kitty"]=" "
  ["librewolf"]=" "
  ["Spotify"]=" "
  ["thunderbird"]=" "
  ["dbgate"]=" "
  ["libreoffice"]=" "
  ["zathura"]=" "
  ["pavucontrol"]=" "
  ["nemo"]=" "
  ["org.keepassxc.KeePassXC"]="󱕵 "
)

swaymsg -t get_tree | jq -r '.nodes[] | .nodes[]? | "Workspace: \(.name), Class: \(.nodes[]? | .app_id // .window_properties.class)"' >/tmp/sway.tmp
returnV=""

while IFS= read -r line; do
  # Get the workspace Name
  workspace=$(echo "$line" | cut -d':' -f2 | cut -d',' -f1)
  app=$(echo "$line" | cut -d':' -f3 | cut -d',' -f1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  # Special cases
  if [[ "$app" == *"libreoffice"* ]]; then
    app="libreoffice"
  fi

  if [[ -v "icons[$app]" ]]; then
    returnM[$workspace]="${returnM[$workspace]}""${icons[$app]}"
  else
    returnM[$workspace]="${returnM[$workspace]}"""
  fi
done <"/tmp/sway.tmp"

for i in "${!returnM[@]}"; do
  returnV="$returnV""$i:""${returnM[$i]}"
done

echo "$returnV"

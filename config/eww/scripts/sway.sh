#!/bin/bash

declare -A icons
icons=(
  ["kitty"]=" "
  ["librewolf"]=" "
  ["Spotify"]=" "
  ["thunderbird"]=" "
  ["dbgate"]=" "
)

swaymsg -t get_tree | jq -r '.nodes[] | .nodes[]? | "Workspace: \(.name), Class: \(.nodes[]? | .app_id // .window_properties.class)"' >/tmp/sway.tmp
returnV=""

while IFS= read -r line; do
  # Get the workspace Name
  workspace=$(echo "$line" | cut -d':' -f2 | cut -d',' -f1)
  app=$(echo "$line" | cut -d':' -f3 | cut -d',' -f1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  if [[ -v "icons[$app]" ]]; then
    returnV=$returnV"$workspace":"${icons[$app]}"
  else
    returnV=$returnV"$workspace":""
  fi
done <"/tmp/sway.tmp"

echo "$returnV"

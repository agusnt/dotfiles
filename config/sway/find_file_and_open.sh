#!/bin/bash

# Open fzf to select a file
selected_file=$(locate "$HOME" | grep -v '/\.' | fzf \
  --border rounded \
  --color gutter:-1 \
  --prompt "  ")

terminal=0
# There is a file?
if [ -n "$selected_file" ]; then
  # Open file with the default one
  mimetype=$(xdg-mime query filetype "$selected_file")
  default_app_desktop=$(xdg-mime query default "$mimetype")

  if [[ -n "$default_app_desktop" ]]; then
    desktop_file=$(find /usr/share/applications ~/.local/share/applications -name "$default_app_desktop")
    if [ -z "$desktop_file" ]; then
      terminal=1
    else
      terminal_app=$(grep "^Terminal=true$" "$desktop_file")
      if [[ -n "$terminal_app" ]]; then terminal=1; else terminal=0; fi
    fi
  else terminal=0; fi

  if [[ $terminal -eq 0 ]]; then
    # app will open a new window
    nohup xdg-open "$selected_file" > /dev/null 2>&1 & disown
    sleep 0.1s
  else
    # app will  not open a new window
    swaymsg [app_id="fffo"] floating toggle
    xdg-open "$selected_file"
    swaymsg [app_id="fffo"] floating enable, resize set 960 648
  fi
fi

#!/bin/bash
options=" Block\n󰒲 Suspend\n󰐥 Poweroff\n Reboot\n󰍃 Logout"
selected=$(echo -e "$options" | wofi --dmenu --width 130 --height 240 --prompt "Power Menu")

case "$selected" in
" Block") swaylock -f -c 000000 ;; # Usa 'swaylock' en Sway (Wayland)
"󰒲 Suspend") systemctl suspend ;;
"󰐥 Poweroff") systemctl poweroff ;;
" Reboot") systemctl reboot ;;
"󰍃 Logout") swaymsg exit ;; # Para Sway (logout)
esac

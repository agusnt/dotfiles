#!/bin/bash
systemctl --user import-environment WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
while [ ! -e "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" ]; do
  sleep 0.1
done
systemctl --user start sway-session.target
dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY

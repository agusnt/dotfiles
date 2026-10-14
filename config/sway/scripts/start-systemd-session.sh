#!/usr/bin/env bash
# Export the sway environment to systemd --user and D-Bus, and start sway-session.target.

export XDG_CURRENT_DESKTOP=${XDG_CURRENT_DESKTOP:-sway}

systemctl --user import-environment WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP

# Wait (max. 10 s) for the Wayland socket to exist
for _ in $(seq 100); do
  [ -e "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}" ] && break
  sleep 0.1
done

dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
systemctl --user start sway-session.target

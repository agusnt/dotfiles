#!/bin/bash

if ! pgrep systemd-inhibit; then
  systemd-inhibit --what=idle --who="$(whoami)" sleep infinity &
  eww update idle-state="on"
else
  pkill systemd-inhibit
  eww update idle-state="off"
fi

#!/bin/bash

if ps -aux | pgrep "wl-present"; then
  pkill wl-present
else
  wl-present mirror eDP-1 --fullscreen-output HDMI-A-1 --fullscreen
fi

#!/bin/bash

swaynag -t warning -m 'Power Menu'\
            -b 'Shutdown'  'shutdown -h now'\
            -b 'Restart' 'shutdown -r now'\
            -b 'Logout' 'swaymsg exit'\
            -b 'Sleep' 'systemctl sleep'\
            --background=#282828 --text=ddc7a1

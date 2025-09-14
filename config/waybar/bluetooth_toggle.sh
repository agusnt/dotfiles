#!/usr/bin/bash
# bluetooth id, check with hcitool dev
ID="AC:F2:3C:F6:D3:C4"

if hcitool dev | grep -q "$ID"; then
  bluetoothctl power off
else
  bluetoothctl power on
fi

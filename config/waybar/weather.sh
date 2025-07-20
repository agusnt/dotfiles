#!/bin/bash

# Check if we have internet
if ! wget -q --spider http://google.com; then
  echo "󱘖 "
  exit
fi

curl "wttr.in?format="+%c+%t""


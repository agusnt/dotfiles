#!/bin/bash
# $1 -> nework interface

if ip a | grep "$1" | grep -q UP; then
  # The connection is up
  echo "󰛳 "
else
  echo "󰲛 "
fi

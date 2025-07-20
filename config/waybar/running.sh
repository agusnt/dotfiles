#!/usr/bin/bash

# Synchting
if pgrep "syncthing" >/dev/null 2>&1; then
  icons="󱞒 "
  tool="Syncthing"
fi

# Borg
if pgrep "borgmatic" >/dev/null 2>&1; then
  icons="$icons""󱑛 "
  tool="$tool Borg"
fi

# Return
echo "{\"text\": \"$icons\", \"tooltip\": \"$tool\"}"

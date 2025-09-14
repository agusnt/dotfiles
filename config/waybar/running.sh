#!/usr/bin/bash

# Synchting
if pgrep "syncthing" >/dev/null 2>&1; then
  icons=" 󱞒 "
  tool="Syncthing"
fi

if pgrep "ollama" >/dev/null 2>&1; then
  icons="$icons"" "
  tool="$tool Ollama"
fi

# Borg
if pgrep "borgmatic" >/dev/null 2>&1; then
  icons="$icons""󱑛 "
  tool="$tool Borg"
fi

# Docker
if [ -n "$(podman ps -q)" ]; then
  icons="$icons"" "
  tool="$tool Podman ($(podman ps --format '{{.Names}}' | tr '\n' ' ')"
  tool="${tool%?})"
fi

# Return
echo "{\"text\": \"$icons\", \"tooltip\": \"$tool\"}"

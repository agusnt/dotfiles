#!/usr/bin/env bash
# Open a terminal: footclient if a foot server is running, else foot, else the system default.

if pgrep -f 'foot (-s|--server)' >/dev/null && command -v footclient >/dev/null; then
  exec footclient -E "$@"
elif command -v foot >/dev/null; then
  exec foot "$@"
else
  exec x-terminal-emulator "$@"
fi

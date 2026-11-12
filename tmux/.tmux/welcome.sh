#!/bin/sh
# Show the cheat sheet the first time tmux is attached
flag="${XDG_STATE_HOME:-$HOME/.local/state}/tmux-welcome-shown"
[ -e "$flag" ] && exit 0
mkdir -p "$(dirname "$flag")" && touch "$flag"
tmux display-popup -E -w 70 -h 40 "$HOME/.tmux/help.sh"
exit 0

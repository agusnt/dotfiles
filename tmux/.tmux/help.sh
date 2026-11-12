#!/bin/sh
# Cheat sheet with the most common tmux keys (prefix = Ctrl-Space)
# Center the block in the popup (horizontally by its longest line, and vertically)
cols=$(tput cols); rows=$(tput lines)
cat <<'TXT' | awk -v cols="$cols" -v rows="$rows" '
  { l[NR] = $0; if (length($0) > w) w = length($0) }
  END {
    px = int((cols - w) / 2); if (px < 0) px = 0
    py = int((rows - NR - 2) / 2); if (py < 0) py = 0
    for (i = 0; i < py; i++) print ""
    for (i = 1; i <= NR; i++) printf "%*s%s\n", px, "", l[i]
    printf "\n%*sPress any key to close... ", px, ""
  }'

  TMUX: the essentials                             (prefix = Ctrl-Space)

  Sessions
    tmux new -A -s Default  create or attach to the "Default" session
    tmux new -s name        new session called "name"
    prefix :  new -s name   new session from inside tmux
    tmux ls                 list sessions
    tmux attach -t name     attach to a session
    prefix d                detach (session keeps running)
    prefix o                find/switch session (sessionx)
    prefix $                rename session

  Windows
    prefix c                new window
    prefix 1..9             go to window N
    prefix &                close window
    prefix ,                rename window

  Panes
    prefix %   /   prefix "      split vertical / horizontal
    prefix h j k l          move between panes
    prefix H J K L          resize pane
    prefix z                zen mode: center the pane (toggle)
    prefix Z                zoom pane
    prefix x                close pane

  Other
    prefix [                copy mode (vi: v, y)
    prefix r                reload config
    prefix I                install plugins (TPM)
    prefix F                fingers (copy with hints)
    prefix /                show this help

TXT
read -r _ </dev/tty

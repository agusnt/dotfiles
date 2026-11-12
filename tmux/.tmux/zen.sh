#!/bin/sh
# Toggle zen mode: center the only pane between two empty side panes
# Width of the centered pane is @zen-width (default 150 columns)
win=$(tmux display -p '#{window_id}')
sides=$(tmux list-panes -t "$win" -F '#{pane_id} #{pane_title}' | awk '$2 == "zen-side" { print $1 }')

if [ -n "$sides" ]; then
    for p in $sides; do tmux kill-pane -t "$p"; done
    tmux set -wu @zen
    tmux refresh-client -S
    exit 0
fi

if [ "$(tmux display -p '#{window_panes}')" -ne 1 ]; then
    tmux display "Zen: needs a single pane"
    exit 0
fi

zen_width=$(tmux show -gv @zen-width 2>/dev/null)
zen_width=${zen_width:-150}
width=$(tmux display -p '#{window_width}')
side=$(((width - zen_width) / 2))
if [ "$side" -lt 1 ]; then
    tmux display "Zen: window is not wider than $zen_width columns"
    exit 0
fi

main=$(tmux display -p '#{pane_id}')
left=$(tmux split-window -d -hb -l "$side" -t "$main" -P -F '#{pane_id}' 'tail -f /dev/null')
right=$(tmux split-window -d -h -l "$side" -t "$main" -P -F '#{pane_id}' 'tail -f /dev/null')
tmux select-pane -t "$left" -T zen-side
tmux select-pane -t "$right" -T zen-side
tmux set -w @zen 1
tmux refresh-client -S

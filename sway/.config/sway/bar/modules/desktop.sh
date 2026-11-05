#!/usr/bin/env bash
# Brightness, Do Not Disturb, camera, window layout and bar log modules
# (sourced by ../bar.sh)

# Brightness: first backlight device, builtins only. Hidden without a backlight.
backlights=(/sys/class/backlight/*)

mod_bright() {
  local d=${backlights[0]} b m
  bright=""
  [[ -r $d/brightness && -r $d/max_brightness ]] || return
  read -r b <"$d/brightness"
  read -r m <"$d/max_brightness"
  ((m > 0)) || return
  b=$((b * 100 / m))
  level "$b" "${ICON_BRIGHT[@]}"
  bright=$REPLY
}

# Do Not Disturb (mako mode), shown only while active
mod_dnd() {
  dnd=""
  [[ -v have[makoctl] ]] || return
  [[ $(makoctl mode 2>/dev/null) == *do-not-disturb* ]] && dnd=$ICON_DND
}

# Camera in use: some process other than wireplumber (which only probes the
# devices) has a /dev/video* open. Needs fuser (psmisc).
cam_notified=0

mod_cam() {
  local pid comm in_use=0
  cam=""
  cam_c=""
  [[ -v have[fuser] ]] || return
  compgen -G '/dev/video*' >/dev/null || return
  for pid in $(fuser /dev/video* 2>/dev/null); do
    read -r comm <"/proc/$pid/comm" 2>/dev/null || continue
    [[ $comm == wireplumber ]] || in_use=1
  done
  if ((in_use)); then
    cam=$ICON_CAM
    cam_c=$GRN
    track cam open
    if ((REPLY && EPOCHSECONDS - cam_notified >= 30)); then
      cam_notified=$EPOCHSECONDS
      notify -u low "Camera" "Camera in use"
    fi
  else
    track cam closed
  fi
}

# Layout of the focused container's parent, plus the nearest enclosing split
# (where the next window goes once you leave a tabbed/stacked container):
# "parent|split". layout_loop runs in the background and prints it on every
# window/binding event.
layout_probe() {
  swaymsg -t get_tree 2>/dev/null |
    jq -r 'def f(anc): (anc + [.layout]) as $a
        | if .focused then anc else (.nodes[]?, .floating_nodes[]?) | f($a) end;
      first(f([])) // empty
      | .[2:] as $a   # drop root and output
      | "\($a[-1] // "none")|\($a | reverse | map(select(. == "splith" or . == "splitv")) | first // "")"' 2>/dev/null
}

layout_loop() {
  local ev_fd
  trap '[[ -n $ev_pid ]] && kill "$ev_pid" 2>/dev/null' EXIT
  layout_probe
  exec {ev_fd}< <(exec swaymsg -t subscribe -m '["window","binding"]' 2>/dev/null)
  ev_pid=$!
  while read -r -u "$ev_fd" _; do
    # the binding event arrives before the command takes effect
    while read -r -t 0.15 -u "$ev_fd" _; do :; done
    layout_probe
  done
}

# Icons: the parent layout (tabs, stack or split) and, next to tabs/stack, the
# enclosing split showing how the next window will be placed
mod_layout() {
  local parent split
  IFS='|' read -r parent split <<<"$layout_raw"
  layout=""
  case $parent in
  tabbed) layout=$ICON_LAYOUT_TABS ;;
  stacked) layout=$ICON_LAYOUT_STACK ;;
  splith) layout=$ICON_LAYOUT_SPLITH ;;
  splitv) layout=$ICON_LAYOUT_SPLITV ;;
  *) return ;;
  esac
  if [[ $parent == tabbed || $parent == stacked ]]; then
    case $split in
    splith) layout+=" $ICON_LAYOUT_SPLITH" ;;
    splitv) layout+=" $ICON_LAYOUT_SPLITV" ;;
    esac
  fi
}

# Errors written to $log since the last click on the indicator
log_seen=0

mod_log() {
  local size
  log_s=""
  [[ -f $log ]] || return
  size=$(stat -c %s "$log") || return
  ((size < log_seen)) && log_seen=0 # rotated
  ((size > log_seen)) && log_s=$ICON_LOG
  log_size=$size
}

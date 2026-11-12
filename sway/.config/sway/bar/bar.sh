#!/usr/bin/env bash
# Status bar for swaybar (Debian). i3bar JSON protocol.
# Single process: /proc and /sys reads with builtins, slow modules with
# their own interval, and events (sway, playerctl) read without blocking.
# Modules live in modules/*.sh. Errors are appended to $XDG_RUNTIME_DIR/bar.log
# (rotated to bar.log.1 above 256 KiB).
# Optional packages: playerctl, libnotify-bin (notify-send), pavucontrol.
# `bar.sh --once` prints a single frame (for debugging) and exits.
# `bar.sh --log` also writes a full trace (set -x with timestamps, file:line) to
# $XDG_RUNTIME_DIR/bar-debug.log, truncated on every start. Combine it with
# --once for a short trace: `bar.sh --once --log`.

export LC_NUMERIC=C     # '.' as decimal separator (EPOCHREALTIME, read -t)
export LC_TIME=C        # dates always in English
export LC_CTYPE=C.UTF-8 # ${var:0:n} must cut characters, not bytes
once=0 debug=0
for _a in "$@"; do
  case $_a in
  --once) once=1 ;;
  --log) debug=1 ;;
  *) echo "usage: bar.sh [--once] [--log]" >&2; exit 2 ;;
  esac
done
unset _a
log=${XDG_RUNTIME_DIR:-/tmp}/bar.log
[[ -f $log && $(stat -c %s "$log") -gt 262144 ]] && mv -f "$log" "$log.1"
exec 2>>"$log"

if ((debug)); then
  debug_log=${XDG_RUNTIME_DIR:-/tmp}/bar-debug.log
  exec {BASH_XTRACEFD}>"$debug_log"
  PS4='+ ${EPOCHREALTIME} ${BASH_SOURCE##*/}:${LINENO}: '
  trap 'echo "bar: exit status $? (line $LINENO)" >&$BASH_XTRACEFD' EXIT
  set -x
  echo "bar: trace in $debug_log" >&2
fi

dir=$(dirname "$(readlink -f "$0")")

# swaybar sends click events on stdin. Keep them on a private descriptor and give
# every command run from here /dev/null as stdin, so none can swallow a click.
if ((! once)); then
  exec {click_fd}<&0 </dev/null
else
  click_fd=0
fi

# Shared colour palette; if the colors/ repo is not next to this one, fall back
# to the generated colors.conf ("set $c_NAME #hex" -> C_NAME=hex)
if [[ -r $dir/../../colors/palette.sh ]]; then
  . "$dir/../../colors/palette.sh"
else
  while read -r _s _n _v; do
    [[ $_s == set && $_n == '$c_'* ]] && printf -v "C_${_n#\$c_}" '%s' "${_v#\#}"
  done <"$dir/../colors.conf"
  unset _s _n _v
fi
RED="#$C_red_b"
GRN="#$C_green_b"
BLU="#$C_blue_b"
YEL="#$C_yellow_b"
DIM="#$C_bg4"
WHT="#$C_fg_b"

. "$dir/../lib/settings.sh" # thresholds, BACKUP_STAMP, BACKUP_WARN_H (CITY is only used by dashboard.sh)
. "$dir/icons.sh"

for f in "$dir"/modules/*.sh; do . "$f"; done

# --- Events / background tasks (read without blocking) ----------------------

# Keyboard layout: initial value + sway events
IFS='|' read -r kbd_n kbd_name < <(swaymsg -t get_inputs 2>/dev/null |
  jq -r '[.[] | select(.type == "keyboard")][0] // empty | "\(.xkb_layout_names | length)|\(.xkb_active_layout_name)"' 2>/dev/null)
: "${kbd_n:=1}"
caps=(/sys/class/leds/*::capslock/brightness)
exec {kbd_fd}< <(swaymsg -t subscribe -m '["input"]' 2>/dev/null |
  jq --unbuffered -r 'select(.change == "xkb_layout") | .input.xkb_active_layout_name' 2>/dev/null)

# Network state: a background process prints one line per change (see network.sh)
exec {net_fd}< <(net_loop)
read -r -t 2 -u "$net_fd" net_raw # first state, so the first frame is complete
net_prev=

# Layout of the focused container (see desktop.sh)
exec {lay_fd}< <(layout_loop)
read -r -t 2 -u "$lay_fd" layout_raw

# Media player (status|artist - title), only if playerctl is installed
if [[ -v have[playerctl] ]]; then
  exec {media_fd}< <(playerctl --follow metadata --format '{{status}}|{{artist}} - {{title}}' 2>/dev/null)
else
  media_fd=""
fi

# Audio events (volume, mute, default device): vol/mic/bt are only refreshed
# when PulseAudio/PipeWire reports a change, or every 30 s as a safety net.
# Without pactl they fall back to polling every 2 s.
if [[ -v have[pactl] ]]; then
  exec {aud_fd}< <(pactl subscribe 2>/dev/null | grep --line-buffered -E "sink|source|server")
else
  aud_fd=""
fi

# Descriptor that never receives data: `read -t 1` works as sleep without spawning a process
exec {sleep_fd}<> <(:)

# Run a detached command if installed: run CMD [ARGS...]
run() {
  [[ -v have[$1] ]] && setsid -f "$@" >/dev/null 2>&1
}

# Actions when a block is clicked (click_events); buttons: 1 left, 3 right, 4 wheel up, 5 wheel down
handle_click() {
  local name button=1
  [[ $click == '[' ]] && return # opening line of the event stream
  # swaybar writes JSON with spaces after the colons: { "name": "vol", ... }
  [[ $click =~ \"name\"[[:space:]]*:[[:space:]]*\"([a-z_]+)\" ]] || {
    echo "bar: click without a known block: $click" >&2
    return
  }
  name=${BASH_REMATCH[1]}
  [[ $click =~ \"button\"[[:space:]]*:[[:space:]]*([0-9]+) ]] && button=${BASH_REMATCH[1]}
  case $name in
  vol)
    case $button in
    4) "$dir/../scripts/vol.sh" up ;;
    5) "$dir/../scripts/vol.sh" down ;;
    3) run pavucontrol ;;
    *) "$dir/../scripts/vol.sh" mute ;; # left click: toggle mute
    esac
    ;;
  mic)
    case $button in
    3) run pavucontrol ;;
    4) wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 2%+ ;; # input gain
    5) wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 2%- ;;
    *) "$dir/../scripts/mic.sh" ;; # left click: toggle mute
    esac
    ;;
  failed) notify "Failed units" "$failed_info" ;;
  gov) notify "Power profile" "$gov_info" ;;
  battery) notify "Battery" "$battery_info" ;;
  wifi)
    case $button in
    3) run nm-connection-editor ;;
    *) notify "WiFi" "$wifi_info" ;;
    esac
    ;;
  eth | phone) run nm-connection-editor ;;
  media)
    case $button in
    4) run playerctl next ;;
    5) run playerctl previous ;;
    *) run playerctl play-pause ;;
    esac
    ;;
  bright)
    case $button in
    4) "$dir/../scripts/bright.sh" up ;;
    5) "$dir/../scripts/bright.sh" down ;;
    esac
    ;;
  dnd)
    makoctl mode -t do-not-disturb >/dev/null 2>&1
    mod_dnd
    ;;
  log)
    notify "Bar errors" "$(tail -n 5 "$log")"
    log_seen=$log_size
    ;;
  kbd) swaymsg input type:keyboard xkb_switch_layout next >/dev/null 2>&1 ;;
  esac
}

# --- Main loop --------------------------------------------------------------

((once)) || printf '{"version":1,"click_events":true}\n[\n'

prev_blocks=

for ((t = 0; ; t++)); do
  # Every second (all builtins, no processes)
  mod_cpu
  mod_ram
  mod_temp
  printf -v date '%(%a %d/%m %H:%M)T' -1
  wg=""
  [[ -n $WG_IFACE ]] && { [[ -e /sys/class/net/$WG_IFACE ]] && wg=$ICON_VPN_UP || wg=$ICON_VPN_DOWN; }

  # Events
  drain "$kbd_fd" kbd_name
  drain "$lay_fd" layout_raw
  mod_layout
  mod_bright
  [[ -n $media_fd ]] && drain "$media_fd" media_raw
  drain "$net_fd" net_raw
  [[ $net_raw != "$net_prev" ]] && {
    net_prev=$net_raw
    mod_net
  }
  # Handle every pending click, not just the last one (fast wheel scrolling)
  ((once)) || while read -t 0 -u "$click_fd" && read -r -u "$click_fd" click; do handle_click; done

  # Own intervals
  ((t % 60 == 0)) && mod_failed
  ((t % 300 == 0)) && mod_backup
  ((t % 30 == 0)) && mod_disk
  ((t % 10 == 0)) && mod_log
  ((t % 5 == 0)) && {
    mod_dnd
    mod_cam
    declare -F mod_battery >/dev/null && mod_battery
    mod_procs
    mod_gov
  }
  audio_dirty=0
  if [[ -n $aud_fd ]]; then
    while read -t 0 -u "$aud_fd"; do
      read -r -u "$aud_fd" _ || break
      audio_dirty=1
    done
    ((t % 30 == 0)) && audio_dirty=1
  else
    ((t % 2 == 0)) && audio_dirty=1
  fi
  ((audio_dirty)) && {
    mod_vol
    declare -F mod_bt >/dev/null && mod_bt
  }
  mod_media

  case $kbd_name in
  *US*) kbd="us" ;;
  *Spanish*) kbd="es" ;;
  *) kbd="" ;;
  esac
  ((kbd_n > 1)) || kbd=""
  if [[ -r ${caps[0]} ]]; then
    read -r c <"${caps[0]}"
    ((c)) && kbd+="${kbd:+ }CAPS"
  fi

  blocks=""
  # Groups by function, separated by a bar
  group # audio and media
  add others "$others"
  add media "$media" "$media_c"
  add vol "$vol" "$vol_c"
  add bt "$bt" "$BLU"
  add mic "$mic" "$mic_c"
  add cam "$cam" "$cam_c"
  add bright "$bright"
  group # system load
  add cpu "$cpu" "$cpu_c" "$cpu_ic"
  add ram "$ram" "$ram_c" "$ram_ic"
  add temp "$temp" "$temp_c" "$temp_ic"
  add disk "$disk" "$disk_c" "$disk_ic"
  group # network
  add wifi "$wifi_s" "$wifi_c" "$wifi_ic"
  add eth "$eth_s" "$eth_c" "$eth_ic"
  add phone "$phone_s" "$phone_c" "$phone_ic"
  [[ -n $borg$wg ]] && add data "$borg$wg"
  group # machine status
  add backup "$backup" "$backup_c"
  add failed "$failed" "$RED"
  add gov "$gov"
  add battery "$battery" "" "$battery_ic"
  add layout "$layout" "$WHT"
  add dnd "$dnd"
  add log "$log_s" "$RED"
  add kbd "$kbd"
  group # clock
  add date "$date"

  # Only redraw swaybar when something changed
  if [[ $blocks != "$prev_blocks" ]]; then
    printf '[%s],\n' "$blocks"
    prev_blocks=$blocks
  fi
  if ((once)); then
    pkill -P $$ # background readers
    break
  fi

  # Sleep until the start of the next second
  us=$((1000000 - 10#${EPOCHREALTIME#*.}))
  printf -v wait '0.%06d' $((us % 1000000))
  ((us == 1000000)) && wait=1
  read -rt "$wait" -u "$sleep_fd"
done

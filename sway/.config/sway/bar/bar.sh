#!/usr/bin/env bash
# Status bar for swaybar (Debian). i3bar JSON protocol.
# Single process: /proc and /sys reads with builtins, slow modules with
# their own interval, and events (sway, playerctl) read without blocking.
# Modules live in modules/*.sh. Errors are appended to $XDG_RUNTIME_DIR/bar.log
# (rotated to bar.log.1 above 256 KiB).
# Optional packages: playerctl, libnotify-bin (notify-send), pavucontrol.

export LC_NUMERIC=C # '.' as decimal separator (EPOCHREALTIME, read -t)
export LC_TIME=C    # dates always in English
log=${XDG_RUNTIME_DIR:-/tmp}/bar.log
[[ -f $log && $(stat -c %s "$log") -gt 262144 ]] && mv -f "$log" "$log.1"
exec 2>>"$log"

dir=$(dirname "$(readlink -f "$0")")

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

. "$dir/../lib/settings.sh" # thresholds, BACKUP_STAMP, BACKUP_WARN_H (CITY is only used by dashboard.sh)

for f in "$dir"/modules/*.sh; do . "$f"; done

# --- Events / background tasks (read without blocking) ----------------------

# Keyboard layout: initial value + sway events
kbd_name=$(swaymsg -t get_inputs 2>/dev/null |
  jq -r '[.[] | select(.type == "keyboard") | .xkb_active_layout_name][0] // empty' 2>/dev/null)
kbd_n=$(swaymsg -t get_inputs 2>/dev/null |
  jq -r '[.[] | select(.type == "keyboard") | .xkb_layout_names | length][0] // 1' 2>/dev/null)
exec {kbd_fd}< <(swaymsg -t subscribe -m '["input"]' 2>/dev/null |
  jq --unbuffered -r 'select(.change == "xkb_layout") | .input.xkb_active_layout_name' 2>/dev/null)

# Pending Debian updates (optional: BAR_UPDATES=1 in settings.sh and apt-get present)
updates=0
upd_fd=""
if ((BAR_UPDATES)) && command -v apt-get >/dev/null; then
  exec {upd_fd}< <(while :; do
    apt-get -s full-upgrade 2>/dev/null | grep -c '^Inst'
    sleep 1800
  done)
fi

# Media player (status|artist - title), only if playerctl is installed
if command -v playerctl >/dev/null; then
  exec {media_fd}< <(playerctl --follow metadata --format '{{status}}|{{artist}} - {{title}}' 2>/dev/null)
else
  media_fd=""
fi

# Audio events (volume, mute, default device): vol/mic/bt are only refreshed
# when PulseAudio/PipeWire reports a change, or every 30 s as a safety net.
# Without pactl they fall back to polling every 2 s.
if command -v pactl >/dev/null; then
  exec {aud_fd}< <(pactl subscribe 2>/dev/null | grep --line-buffered -E "sink|source|server")
else
  aud_fd=""
fi

# Descriptor that never receives data: `read -t 1` works as sleep without spawning a process
exec {sleep_fd}<> <(:)

# Actions when a block is clicked (click_events); buttons: 1 left, 3 right, 4 wheel up, 5 wheel down
handle_click() {
  local name button=1
  [[ $click =~ \"name\":\"([a-z_]+)\" ]] || return
  name=${BASH_REMATCH[1]}
  [[ $click =~ \"button\":([0-9]+) ]] && button=${BASH_REMATCH[1]}
  case $name in
  vol)
    case $button in
    4) "$dir/../scripts/vol.sh" up ;;
    5) "$dir/../scripts/vol.sh" down ;;
    *) command -v pavucontrol >/dev/null && setsid -f pavucontrol >/dev/null 2>&1 ;;
    esac
    ;;
  mic)
    case $button in
    3) command -v pavucontrol >/dev/null && setsid -f pavucontrol >/dev/null 2>&1 ;;
    *) "$dir/../scripts/mic.sh" ;; # left click: toggle mute
    esac
    ;;
  failed) command -v notify-send >/dev/null && notify-send -e "Failed units" "$failed_info" ;;
  gov) command -v notify-send >/dev/null && notify-send -e "Power profile" "$gov_info" ;;
  battery) command -v notify-send >/dev/null && notify-send -e "Battery" "$battery_info" ;;
  wifi | eth | phone) command -v nm-connection-editor >/dev/null && setsid -f nm-connection-editor >/dev/null 2>&1 ;;
  media) command -v playerctl >/dev/null && setsid -f playerctl play-pause >/dev/null 2>&1 ;;
  esac
}

# --- Main loop --------------------------------------------------------------

printf '{"version":1,"click_events":true}\n[\n'

prev_blocks=

for ((t = 0; ; t++)); do
  # Every second (all builtins, no processes)
  mod_cpu
  mod_ram
  mod_temp
  printf -v date '[%(%a %d/%m %H:%M)T]' -1
  wg=""
  [[ -n $WG_IFACE ]] && { [[ -e /sys/class/net/$WG_IFACE ]] && wg="󰦝" || wg="󰦜"; }

  # Events
  drain "$kbd_fd" kbd_name
  [[ -n $upd_fd ]] && drain "$upd_fd" updates
  [[ -n $media_fd ]] && drain "$media_fd" media_raw
  # Handle every pending click, not just the last one (fast wheel scrolling)
  while read -t 0 -u 0 && read -r click; do handle_click; done

  # Own intervals
  ((t % 60 == 0)) && mod_failed
  ((t % 300 == 0)) && mod_backup
  ((t % 30 == 0)) && mod_disk
  ((t % 10 == 0)) && mod_net
  ((t % 5 == 0)) && {
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
  [[ -n $kbd ]] && kbd="[$kbd"
  if [[ -r ${caps[0]} ]]; then
    read -r c <"${caps[0]}"
    ((c)) && kbd+=" CAPS"
  fi
  [[ -n $kbd ]] && kbd+="]"

  upd=""
  ((updates > 0)) && upd="󰏕 "

  blocks=""
  # Groups by function, separated by a bar
  group # audio and media
  add others "$others"
  add media "$media" "$media_c"
  add vol "$vol" "$vol_c"
  add bt "$bt" "$BLU"
  add mic "$mic" "$mic_c"
  group # system load
  add cpu "$cpu" "$cpu_c" "$cpu_ic"
  add ram "$ram" "$ram_c" "$ram_ic"
  add temp "$temp" "$temp_c" "$temp_ic"
  add disk "$disk" "$disk_c" "$disk_ic"
  group # network
  add wifi "$wifi_s" "$wifi_c" "$wifi_ic"
  add eth "$eth_s" "$eth_c" "$eth_ic"
  add phone "$phone_s" "$phone_c" "$phone_ic"
  [[ -n $borg$wg$upd ]] && add data "[$upd$borg$wg]"
  group # machine status
  add backup "$backup" "$backup_c"
  add failed "$failed" "$RED"
  add gov "$gov"
  add battery "$battery" "" "$battery_ic"
  add kbd "$kbd"
  group # clock
  add date "$date"

  # Only redraw swaybar when something changed
  if [[ $blocks != "$prev_blocks" ]]; then
    printf '[%s],\n' "$blocks"
    prev_blocks=$blocks
  fi

  # Sleep until the start of the next second
  us=$((1000000 - 10#${EPOCHREALTIME#*.}))
  printf -v wait '0.%06d' $((us % 1000000))
  ((us == 1000000)) && wait=1
  read -rt "$wait" -u "$sleep_fd"
done

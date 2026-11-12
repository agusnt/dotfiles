#!/usr/bin/env bash
# Audio, Bluetooth and media modules (sourced by ../bar.sh)

bt=""
mic_notified=0
sink_bluez=0

# True if an application is capturing from a source (ignores volume meters
# such as pavucontrol's peak detect). Without pactl it is always false.
mic_in_use() {
  [[ -v have[pactl] ]] || return 1
  [[ -n $(pactl list source-outputs 2>/dev/null | awk '
    /^Source Output/ { if (n && !skip) print "x"; skip=0; n=1 }
    /application.id = .*pavucontrol|Peak detect/ { skip=1 }
    END { if (n && !skip) print "x" }') ]]
}

mod_vol() {
  local out v muted
  vol=""
  vol_c=""
  mic=""
  mic_c=""
  sink_bluez=0
  out=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null) || return
  read -r _ v muted <<<"$out"
  v=$((10#${v/./}))
  level "$v" "${ICON_VOL[@]}"
  vol=$REPLY
  [[ $muted == *MUTED* ]] && vol=$ICON_VOL_MUTE && vol_c=$RED
  # Bluetooth sink: prefix the Bluetooth audio icon to the volume icon
  [[ $(wpctl inspect @DEFAULT_AUDIO_SINK@ 2>/dev/null) == *bluez* ]] && sink_bluez=1 && vol="$ICON_VOL_BT $vol"
  printf -v vol '%s %3d%%' "$vol" "$v"

  out=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null) || return
  if [[ $out == *MUTED* ]]; then
    mic=$ICON_MIC_MUTE
    mic_c=$RED # muted
    track mic closed
  elif mic_in_use; then
    mic=$ICON_MIC
    mic_c=$GRN # an application is capturing
    track mic open
    # At most one notification per 30 s: browsers open and close streams often
    if ((REPLY && EPOCHSECONDS - mic_notified >= 30)); then
      mic_notified=$EPOCHSECONDS
      notify -u low "Microphone" "Microphone in use"
    fi
  else
    # Idle: dim icon, so the blocks to its right do not shift when it changes
    mic=$ICON_MIC
    mic_c=$DIM
    track mic closed
  fi
}

# Bluetooth: icon whenever the adapter is powered (connected icon when a
# device is connected or the default sink is bluez). Runs after mod_vol, which
# sets $sink_bluez.
mod_bt() {
  bt=""
  [[ -v have[bluetoothctl] ]] || return
  # No adapter: skip without spawning anything. bluetoothctl can hang for
  # ~25 s when bluetoothd does not answer, so it always runs under timeout.
  compgen -G '/sys/class/bluetooth/hci*' >/dev/null || return
  [[ $(timeout 1 bluetoothctl show 2>/dev/null) == *"Powered: yes"* ]] || return
  bt=$ICON_BT
  if ((sink_bluez)) || [[ -n $(timeout 1 bluetoothctl devices Connected 2>/dev/null) ]]; then
    bt=$ICON_BT_CONN
  fi
}

mod_media() {
  local st info
  media=""
  media_c=""
  [[ -n $media_raw ]] || return
  st=${media_raw%%|*}
  info=${media_raw#*|}
  [[ $st == Playing || $st == Paused ]] || return
  ((${#info} > 40)) && info="${info:0:39}…"
  media="$ICON_MEDIA $info"
  [[ $st == Paused ]] && media_c=$DIM
}

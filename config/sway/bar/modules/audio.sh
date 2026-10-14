#!/usr/bin/env bash
# Audio, Bluetooth and media modules (sourced by ../bar.sh)

bt=""
mic_notified=0

# True if an application is capturing from a source (ignores volume meters
# such as pavucontrol's peak detect). Without pactl it is always false.
mic_in_use() {
  command -v pactl >/dev/null || return 1
  [[ -n $(pactl list source-outputs 2>/dev/null | awk '
    /^Source Output/ { if (n && !skip) print "x"; skip=0; n=1 }
    /application.id = .*pavucontrol|Peak detect/ { skip=1 }
    END { if (n && !skip) print "x" }') ]]
}

mod_vol() {
  local out v muted
  out=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null) || return
  read -r _ v muted <<<"$out"
  v=$((10#${v/./}))
  level "$v" 󰕿 󰖀 󰕾
  vol=$REPLY
  vol_c=""
  [[ $muted == *MUTED* ]] && vol="󰖁" && vol_c=$RED
  printf -v vol '[%s %3d%%]' "$vol" "$v"

  out=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null) || return
  mic=""
  if [[ $out == *MUTED* ]]; then
    mic="[󰍭]"
    mic_c=$RED # muted
    track mic closed
  elif mic_in_use; then
    mic="[󰍬]"
    mic_c=$GRN # an application is capturing
    track mic open
    # At most one notification per 30 s: browsers open and close streams often
    if ((REPLY && EPOCHSECONDS - mic_notified >= 30)); then
      mic_notified=$EPOCHSECONDS
      notify -u low "Microphone" "Microphone in use"
    fi
  else
    # Idle: dim icon, so the blocks to its right do not shift when it changes
    mic="[󰍬]"
    mic_c=$DIM
    track mic closed
  fi
}

# Bluetooth: icon whenever the adapter is powered (󰂱 when a device is
# connected or the default sink is bluez), refreshed with the audio state
mod_bt() {
  bt=""
  command -v bluetoothctl >/dev/null || return
  [[ $(bluetoothctl show 2>/dev/null) == *"Powered: yes"* ]] || return
  bt="[󰂯]"
  if [[ $(wpctl inspect @DEFAULT_AUDIO_SINK@ 2>/dev/null) == *bluez* ||
    -n $(bluetoothctl devices Connected 2>/dev/null) ]]; then
    bt="[󰂱]"
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
  media="[󰝚 $info]"
  [[ $st == Paused ]] && media_c=$DIM
}

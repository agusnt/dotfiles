#!/usr/bin/env bash
# Nerd Font icons used by the bar (sourced by ../bar.sh before the modules)

# Incremental icons: pie slices for usage, thermometer for temperature
ICON_SLICE=(󰪞 󰪟 󰪠 󰪡 󰪢 󰪣 󰪤 󰪥)
ICON_THERM=(󱃃 󰔏 󱃂)

# Network
ICON_WIFI=(󰤯 󰤟 󰤢 󰤥 󰤨)
ICON_WIFI_OFF="󰖪" # adapter present, not connected
ICON_ETH="󰈀"
ICON_PHONE="" # metered wired link = tethering
ICON_VPN_UP="󰦝"
ICON_VPN_DOWN="󰦜"
ICON_BORG="󰸧"

# Audio
ICON_VOL=(󰕿 󰖀 󰕾)
ICON_VOL_MUTE="󰖁"
ICON_VOL_BT="󰂰" # prefix when the sink is Bluetooth
ICON_MIC="󰍬"
ICON_MIC_MUTE="󰍭"
ICON_BT="󰂯"
ICON_BT_CONN="󰂱"
ICON_MEDIA="󰝚"

# Power
ICON_BAT=(󰁺 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)
ICON_BAT_CHARGE="󰂄"
ICON_BAT_PLUG=""     # plugged in, not charging (full or charge limit)
ICON_GOV_SAVER="󰌪"    # leaf
ICON_GOV_BALANCED="󰗑" # scale
ICON_GOV_PERF="󱓞"     # rocket
ICON_GOV_UNKNOWN="󰋗"

# Desktop
ICON_BRIGHT=(󰃞 󰃟 󰃠)
ICON_DND="󰂛" # notifications silenced
ICON_CAM="󰄀" # camera in use

ICON_LAYOUT_TABS="󰓩"
ICON_LAYOUT_STACK=""
ICON_LAYOUT_SPLITH="" # next window goes to the right
ICON_LAYOUT_SPLITV="" # next window goes below

# Misc
ICON_LOG="󰃤" # new errors in bar.log
ICON_FAILED="󰀦"
ICON_BACKUP="󰁯"
ICON_OTHERS="󰈈"

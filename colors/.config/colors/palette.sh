#!/usr/bin/env bash
# Single source of truth for the colour palette (gruvbox dark, original).
# Hex values WITHOUT the leading '#'.
#
# - sway/bar/bar.sh sources this file directly.
# - colors/apply.sh generates sway/colors.conf and foot/colors.ini from it.
# - mako, swaylock and wofi cannot include other files: they keep literal
#   values, which `colors/apply.sh check` verifies against this palette.

# Backgrounds, darkest first
C_bg_h=1d2021 # bar, launcher, notifications
C_bg=282828
C_bg1=3c3836
C_bg2=504945
C_bg3=665c54
C_bg4=7c6f64 # dimmed text, "bright black"

# Foregrounds
C_gray=a89984
C_fg=ebdbb2
C_fg_b=fbf1c7

# Accents: normal and bright variants
C_red=cc241d
C_red_b=fb4934
C_green=98971a
C_green_b=b8bb26
C_yellow=d79921
C_yellow_b=fabd2f
C_blue=458588
C_blue_b=83a598
C_purple=b16286
C_purple_b=d3869b
C_aqua=689d6a
C_aqua_b=8ec07c
C_orange=d65d0e
C_orange_b=fe8019

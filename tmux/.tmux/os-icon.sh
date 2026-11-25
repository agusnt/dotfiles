#!/bin/sh
# Pick the Nerd Font logo of the running OS and store it in the tmux option
# @os_icon (used by status-left). Reads ID, then ID_LIKE, from /etc/os-release.
# Override with: set -g @os_icon_override "<glyph>" before this runs.
icon_for() {
  case $1 in
    arch) echo '' ;;
    archarm) echo '' ;;
    artix) echo '' ;;
    endeavouros) echo '' ;;
    manjaro) echo '' ;;
    garuda) echo '' ;;
    debian) echo '' ;;
    ubuntu) echo '' ;;
    linuxmint) echo '' ;;
    pop) echo '' ;;
    elementary) echo '' ;;
    kali) echo '' ;;
    raspbian) echo '' ;;
    fedora) echo '' ;;
    rhel) echo '' ;;
    centos) echo '' ;;
    rocky) echo '' ;;
    almalinux) echo '' ;;
    opensuse*|sles|suse) echo '' ;;
    gentoo) echo '' ;;
    nixos) echo '' ;;
    alpine) echo '' ;;
    void) echo '' ;;
    slackware) echo '' ;;
    mageia) echo '' ;;
    *) return 1 ;;
  esac
}

if [ "$(uname -s)" = Darwin ]; then
  icon=$(printf '\357\205\271')   # U+F179 apple
else
  id= like=
  [ -r /etc/os-release ] && . /etc/os-release && id=$ID like=$ID_LIKE
  icon=$(icon_for "$id") ||
    for l in $like; do icon=$(icon_for "$l") && break; done
  [ -n "$icon" ] || icon=$(printf '\357\214\232')   # U+F31A tux (generic Linux)
fi
tmux set -g @os_icon "$icon"

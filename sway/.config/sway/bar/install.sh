#!/usr/bin/env bash
# Install the Debian 13 packages the sway status bar needs.
# Usage: ./install-deps.sh [--required]   (--required: skip the optional packages)
set -euo pipefail

required=(sway jq network-manager pipewire pipewire-pulse wireplumber psmisc procps coreutils brightnessctl fonts-firacode)
optional=(chafa playerctl libnotify-bin pavucontrol network-manager-gnome mako-notifier bluez)

pkgs=("${required[@]}")
[[ ${1:-} == --required ]] || pkgs+=("${optional[@]}")

sudo=""
((EUID == 0)) || sudo=sudo
$sudo apt-get update
$sudo apt-get install -y "${pkgs[@]}"

echo "Nerd Font (not packaged in Debian): install one manually, e.g. https://www.nerdfonts.com/font-downloads" >&2

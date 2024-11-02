#!/bin/bash
# 
# Automatic iterate over the backgroudns of a directory
#
# Parameters:
#   $1: Directory of wallpapers
#   $2: Output screen

[ $# -lt 2 ] && \
    echo "./wallpaper.sh [DIRECTORY] [DURATION]" && exit 1

wallpaper_directory=$1
output=$2

[ ! -d "$wallpaper_directory" ] && \
    echo "./wallpaper.sh [DIRECTORY] [DURATION]" && exit 1

# Get a random file
file=$(ls "$wallpaper_directory" | sort -R | tail -1)

# Get pid of current swayb
wallpaper="$wallpaper_directory/$file"
format=$(file "$wallpaper" | cut -d " " -f 3)
[[ "$format" = "image" ]] && \
    swaymsg output $output bg $wallpaper fill

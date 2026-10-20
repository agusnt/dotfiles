#!/usr/bin/env bash
# Dashboard helpers: colors, caching, formatting and layout (sourced by dashboard.sh).

B=$'\e[1m'
R=$'\e[0m'
DIMC=$'\e[2m'
RED=$'\e[31m'
GRN=$'\e[32m'
YEL=$'\e[33m'
CYN=$'\e[1;36m'

# cached KEY TTL FUNC: print the last output of FUNC. When it is older than TTL
# seconds, FUNC is re-run in the background, so drawing never waits for it.
cached() {
  local f=$cache/$1 age
  if [[ -e $f ]]; then age=$((EPOCHSECONDS - $(stat -c %Y "$f"))); else age=$(($2 + 1)); fi
  if ((age >= $2)) && [[ ! -e $f.run ]]; then
    touch "$f.run"
    ("$3" >"$f.tmp" 2>/dev/null; mv -f "$f.tmp" "$f"; rm -f "$f.run") >/dev/null 2>&1 &
  fi
  if [[ ! -e $f ]]; then
    printf '%sloading…%s\n' "$DIMC" "$R"
  elif [[ -s $f ]]; then
    printf '%s\n' "$(<"$f")"
  fi
}

# title TEXT: section heading
title() { printf '%s%s%s\n' "$CYN" "$1" "$R"; }

# pct_color VALUE: percentage coloured by level
pct_color() {
  local c=$GRN
  if (($1 >= 90)); then c=$RED; elif (($1 >= 70)); then c=$YEL; fi
  printf '%s%s%%%s' "$c" "$1" "$R"
}

# bat_gauge PCT: percentage plus a 10-cell gauge, coloured by the bar's battery
# thresholds (low is bad)
bat_gauge() {
  local c=$GRN gauge rest
  if (($1 <= BAT_CRIT)); then c=$RED; elif (($1 <= BAT_WARN)); then c=$YEL; fi
  printf -v gauge '%*s' $(($1 / 10)) ''
  printf -v rest '%*s' $((10 - $1 / 10)) ''
  printf '%s%3d%%%s %s%s%s%s%s' "$c" "$1" "$R" "$c" "${gauge// /█}" "$DIMC" "${rest// /░}" "$R"
}

# kib_gib KIB: "1.5G"
kib_gib() {
  local g=$(($1 * 10 / 1048576))
  printf '%d.%dG' $((g / 10)) $((g % 10))
}

# bytes_h BYTES: sets REPLY to a short human size (K, M, G)
bytes_h() {
  local b=$1 t
  if ((b >= 1073741824)); then
    t=$((b * 10 / 1073741824))
    REPLY="$((t / 10)).$((t % 10))G"
  elif ((b >= 1048576)); then
    t=$((b * 10 / 1048576))
    REPLY="$((t / 10)).$((t % 10))M"
  else
    REPLY="$((b / 1024))K"
  fi
}

# sbs LEFT RIGHT WIDTH: print two multi-line blocks side by side
sbs() {
  local -a l r
  local i n plain pad
  mapfile -t l <<<"$1"
  mapfile -t r <<<"$2"
  n=${#l[@]}
  ((${#r[@]} > n)) && n=${#r[@]}
  for ((i = 0; i < n; i++)); do
    plain=${l[i]//$'\e'\[*([0-9;])m/}
    pad=""
    ((${#plain} < $3)) && printf -v pad '%*s' $(($3 - ${#plain})) ''
    printf '%s%s%s\n' "${l[i]}" "$pad" "${r[i]}"
  done
}

# clock HH:MM:SS: big 3x5 block digits
declare -A GLYPH=(
  [0]='███|█ █|█ █|█ █|███' [1]=' █ |██ | █ | █ |███' [2]='███|  █|███|█  |███'
  [3]='███|  █|███|  █|███' [4]='█ █|█ █|███|  █|  █' [5]='███|█  |███|  █|███'
  [6]='███|█  |███|█ █|███' [7]='███|  █|  █|  █|  █' [8]='███|█ █|███|█ █|███'
  [9]='███|█ █|███|  █|███' [:]='   | █ |   | █ |   '
)
clock() {
  local -a rows line=()
  local c i r
  for ((i = 0; i < ${#1}; i++)); do
    c=${1:i:1}
    IFS='|' read -ra rows <<<"${GLYPH[$c]}"
    for r in 0 1 2 3 4; do line[r]+="${rows[r]} "; done
  done
  for r in 0 1 2 3 4; do printf '%s%s%s\n' "$CYN" "${line[r]}" "$R"; done
}

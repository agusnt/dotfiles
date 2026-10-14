#!/usr/bin/env bash
# Core helpers (sourced by ../bar.sh)

# & in replacement strings must be literal (bash 5.2 patsub_replacement)
shopt -u patsub_replacement 2>/dev/null

# Read the last available line from an fd without blocking and store it in $2
drain() {
  local -n _out=$2
  local _l
  while read -t 0 -u "$1"; do
    read -r -u "$1" _l || return
    _out=$_l
  done
}

# Separator between groups: vertical bar, dimmed
SEP='│'

# Start a new group: a separator is drawn before its first block
# (except for the first group).
group_start=0
group() {
  group_start=1
}

# Append a block: add NAME TEXT [BLOCK_COLOR] [ICON_COLOR]
# Modules wrap their text in [ ]; the brackets are dropped here. The leading
# icon (a first word that is not alphanumeric) is coloured on its own with
# pango markup, only when ICON_COLOR or BLOCK_COLOR is given: colours only
# signal a measurement, never a category.
blocks=""
add() {
  [[ -n $2 ]] || return
  local t=${2//[[:cntrl:]]/ } icon
  t=${t//\] \[/ }
  t=${t#\[}
  t=${t%\]}
  t=${t//&/&amp;}
  t=${t//</&lt;}
  t=${t//>/&gt;}
  icon=${t%% *}
  [[ $icon == [[:alnum:]]* || -z ${4:-$3} ]] ||
    t="<span foreground='${4:-$3}'>$icon</span>${t#"$icon"}"
  t=${t//\\/\\\\}
  t=${t//\"/\\\"}
  if ((group_start)) && [[ -n $blocks ]]; then
    blocks+=',{"name":"sep","full_text":" '$SEP' ","separator":false,"separator_block_width":0,"color":"'$DIM'"}'
  fi
  group_start=0
  blocks+=${blocks:+,}'{"name":"'$1'","full_text":" '$t' ","markup":"pango","separator":false,"separator_block_width":0'
  [[ -n $3 ]] && blocks+=',"color":"'$3'"'
  blocks+='}'
}

# Colour for a value: heat VALUE [WARN] [CRIT] -> REPLY = none, yellow (>= WARN)
# or red (>= CRIT). Defaults to LOAD_WARN/LOAD_CRIT.
heat() {
  if (($1 >= ${3:-$LOAD_CRIT})); then
    REPLY=$RED
  elif (($1 >= ${2:-$LOAD_WARN})); then
    REPLY=$YEL
  else
    REPLY=""
  fi
}

# Same for values where low is bad (battery, signal): red at or below CRIT,
# yellow at or below WARN
heat_low() {
  if (($1 <= $3)); then
    REPLY=$RED
  elif (($1 <= $2)); then
    REPLY=$YEL
  else
    REPLY=""
  fi
}

# Desktop notification (needs libnotify-bin; silently skipped otherwise)
notify() {
  command -v notify-send >/dev/null && notify-send -e "$@"
}

# Track a state across calls: track KEY VALUE -> REPLY=1 if VALUE changed since
# the previous call. The first observation never counts as a change.
declare -A _state
track() {
  REPLY=0
  [[ -v _state[$1] && ${_state[$1]} != "$2" ]] && REPLY=1
  _state[$1]=$2
}

# Pick an icon by percentage: level PCT ICON... -> REPLY (icons ordered low to high)
level() {
  local p=$1
  shift
  local -a i=("$@")
  ((p < 0)) && p=0
  ((p > 100)) && p=100
  REPLY=${i[p * ${#i[@]} / 101]}
}

# bytes/s -> human-readable, fixed-width REPLY (K/s, M/s)
hr() {
  local b=$1 t
  ((b < 0)) && b=0
  if ((b >= 1048576)); then
    t=$((b * 10 / 1048576))
    printf -v REPLY '%5s' "$((t / 10)).$((t % 10))M/s"
  else
    printf -v REPLY '%5s' "$((b / 1024))K/s"
  fi
}

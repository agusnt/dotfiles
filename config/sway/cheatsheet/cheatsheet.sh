#!/usr/bin/env bash
# Pop-up cheat sheet with the sway and Neovim key bindings. Both tabs are
# parsed from the live config files, so the list never goes stale.
# Usage: cheatsheet.sh toggle|show|hide|dump [sway|nvim] [FILTER]
#   toggle: show it if closed, hide it if open (bound to the ThinkPad Copilot key)
#   show:   open a floating terminal (app_id "sway-cheatsheet") running `view`
#   hide:   close it
#   dump:   print one tab to stdout without a terminal (handy for testing)
# Inside the window: Tab, h/l or 1/2 switch tab, j/k or arrows scroll, g/G top/bottom,
# / filter (empty clears it), q or Esc close. It redraws on terminal resize.

shopt -s extglob
export LC_NUMERIC=C
self=$(readlink -f "$0")
dir=$(dirname "$self")
APP_ID=sway-cheatsheet

case ${1:-} in
toggle)
  if pgrep -f "$self view" >/dev/null; then exec "$self" hide; else exec "$self" show; fi
  ;;
show)
  # Already open: nothing to do
  pgrep -f "$self view" >/dev/null && exit 0
  if pgrep -f 'foot (-s|--server)' >/dev/null && command -v footclient >/dev/null; then
    exec footclient -E -a "$APP_ID" "$self" view
  fi
  exec foot -a "$APP_ID" "$self" view
  ;;
hide)
  swaymsg "[app_id=\"$APP_ID\"] kill" >/dev/null 2>&1
  exit 0
  ;;
view | dump) ;;
*)
  echo "usage: ${0##*/} toggle|show|hide|dump [sway|nvim] [FILTER]" >&2
  exit 1
  ;;
esac

. "$dir/../dashboard/lib.sh" # colours, title, sbs
. "$dir/sway.sh"             # rows_sway
. "$dir/nvim.sh"             # rows_nvim

TABS=(sway nvim)
LABELS=(Sway Neovim)
COLW=60 # width of one column (text + gutter)
KEYW=24 # width of the key column inside a column
MARGIN=2 # blank columns between the window border and the text

tab=0
filter=""
offset=0
cols=120
rows=40
body=() # rendered lines of the current tab

# fmt_desc DESC DETAIL MAX: description, plus the dimmed detail if it still fits
fmt_desc() {
  local d=${1:0:$3} x=$2 room
  room=$(($3 - ${#d} - 2))
  if [[ -n $x ]] && ((room > 2)); then
    printf '%s  %s%s%s' "$d" "$DIMC" "${x:0:room}" "$R"
  else
    printf '%s' "$d"
  fi
}

# render NAME WIDTH: fill `body` with the tab as columns of one block per section
render() {
  local name=$1 width=$2 section keys desc detail cur="" text ncol i k min out btxt=""
  local lower=${filter,,}
  local descw=$((COLW - KEYW - 2))
  local -a blocks=() colt=() coll=() tmp

  while IFS=$'\x1f' read -r section keys desc detail; do
    if [[ -n $filter ]]; then
      text="$section $keys $desc $detail"
      [[ ${text,,} == *"$lower"* ]] || continue
    fi
    if [[ $section != "$cur" ]]; then
      [[ -n $btxt ]] && blocks+=("$btxt")
      cur=$section
      btxt=$(title "${section:0:COLW-2}")
    fi
    btxt+=$'\n'$(printf '%s%-*s%s %s' "$YEL" "$KEYW" "${keys:0:KEYW-1}" "$R" "$(fmt_desc "$desc" "$detail" "$descw")")
  done < <("rows_$name")
  [[ -n $btxt ]] && blocks+=("$btxt")

  if ((${#blocks[@]} == 0)); then
    body=("${DIMC}No bindings match.${R}")
    return
  fi

  ncol=$((width / COLW))
  ((ncol < 1)) && ncol=1
  ((ncol > 3)) && ncol=3
  for ((i = 0; i < ncol; i++)); do
    colt[i]=""
    coll[i]=0
  done
  # Each block goes to the shortest column
  for text in "${blocks[@]}"; do
    mapfile -t tmp <<<"$text"
    k=0
    min=${coll[0]}
    for ((i = 1; i < ncol; i++)); do
      if ((coll[i] < min)); then
        min=${coll[i]}
        k=$i
      fi
    done
    colt[k]+="$text"$'\n\n'
    coll[k]=$((coll[k] + ${#tmp[@]} + 1))
  done
  out=${colt[0]}
  for ((i = 1; i < ncol; i++)); do out=$(sbs "$out" "${colt[i]}" $((COLW * i))); done
  mapfile -t body <<<"$out"
}

if [[ $1 == dump ]]; then
  filter=${3:-}
  render "${2:-sway}" $((${COLUMNS:-120} - 2 * MARGIN))
  printf '%s\n' "${body[@]}"
  exit 0
fi

# --- view -------------------------------------------------------------------

build() {
  cols=$(tput cols 2>/dev/null || echo 120)
  rows=$(tput lines 2>/dev/null || echo 40)
  render "${TABS[tab]}" $((cols - 2 * MARGIN))
}

# clamp: keep `offset` inside the body
clamp() {
  local max=$((${#body[@]} - (rows - 4)))
  ((max < 0)) && max=0
  ((offset > max)) && offset=$max
  ((offset < 0)) && offset=0
  return 0 # the last test may be false; callers chain `&& redraw=1`
}

scroll() {
  offset=$((offset + $1))
  clamp
}

draw() {
  local i end hdr="" rev=$'\e[7m' view=$((rows - 4))
  ((view < 1)) && view=1
  clamp
  end=$((offset + view))
  ((end > ${#body[@]})) && end=${#body[@]}
  for i in "${!TABS[@]}"; do
    if ((i == tab)); then
      hdr+="$rev$B $((i + 1)) ${LABELS[i]} $R "
    else
      hdr+="$DIMC $((i + 1)) ${LABELS[i]} $R "
    fi
  done
  printf '\e[H\n'
  printf '%*s%s\e[K\n' "$MARGIN" '' "$hdr"
  printf '%*s%s\e[K\n' "$MARGIN" '' "${DIMC}Tab/h/l/1/2 tab · j/k scroll · / filter${filter:+ [$filter]} · q close   $((offset + 1))-$end/${#body[@]}$R"
  printf '\e[K\n'
  for ((i = offset; i < end; i++)); do
    printf '%*s%s\e[K\n' "$MARGIN" '' "${body[i]}"
  done
  printf '\e[J'
}

resized=0
trap 'resized=1' WINCH
trap 'printf "\e[?25h"' EXIT
printf '\e[?25l\e[2J'

build
draw
while :; do
  key=""
  redraw=0
  # A WINCH interrupts `read`, which then returns with an empty key
  IFS= read -rsn1 key || true
  if ((resized)); then
    resized=0
    build
    redraw=1
  fi
  case $key in
  q) break ;;
  j) scroll 1 && redraw=1 ;;
  k) scroll -1 && redraw=1 ;;
  ' ') scroll $((rows - 5)) && redraw=1 ;;
  b) scroll $((5 - rows)) && redraw=1 ;;
  g) offset=0 redraw=1 ;;
  G) offset=${#body[@]} redraw=1 ;;
  $'\t' | [1-9] | h | l)
    if [[ $key == $'\t' || $key == l ]]; then
      tab=$(((tab + 1) % ${#TABS[@]}))
    elif [[ $key == h ]]; then
      tab=$(((tab + ${#TABS[@]} - 1) % ${#TABS[@]}))
    elif ((key <= ${#TABS[@]})); then
      tab=$((key - 1))
    else
      continue
    fi
    offset=0
    build
    redraw=1
    ;;
  /)
    printf '\e[%d;1H\e[K%*s/' "$rows" "$MARGIN" ''
    printf '\e[?25h'
    IFS= read -re -i "$filter" filter || true
    printf '\e[?25l'
    offset=0
    build
    redraw=1
    ;;
  $'\e')
    seq=""
    IFS= read -rsn2 -t 0.05 seq || true
    case $seq in
    '[A') scroll -1 && redraw=1 ;;
    '[B') scroll 1 && redraw=1 ;;
    '[5')
      IFS= read -rsn1 -t 0.05 _ || true # swallow the trailing "~"
      scroll $((5 - rows)) && redraw=1
      ;;
    '[6')
      IFS= read -rsn1 -t 0.05 _ || true
      scroll $((rows - 5)) && redraw=1
      ;;
    '') break ;; # a lone Esc closes
    esac
    ;;
  esac
  ((redraw)) && draw
done

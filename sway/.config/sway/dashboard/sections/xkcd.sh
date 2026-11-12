#!/usr/bin/env bash
# xkcd section: the latest comic (or a random one) drawn with chafa
# (sourced by dashboard.sh). State: $cache/xkcd.num holds the chosen number;
# without it the latest comic is shown.

# xkcd_json [NUM]: raw JSON of a comic (latest when NUM is empty)
xkcd_json() { curl -fsS --max-time 10 "https://xkcd.com/${1:+$1/}info.0.json"; }

# xkcd_random: pick a random comic number (runs in the background)
xkcd_random() {
  local max
  max=$(xkcd_json | jq -r .num) || return
  [[ $max == +([0-9]) ]] || return
  echo $((RANDOM % max + 1)) >"$cache/xkcd.num"
  rm -f "$cache"/xkcd_*
}

# xkcd_latest: back to the latest comic
xkcd_latest() {
  rm -f "$cache/xkcd.num" "$cache"/xkcd_*
}

data_xkcd() {
  local n="" j img alt tmp title sixel w left tw=$((cols + 2 * MARGIN))
  [[ -r $cache/xkcd.num ]] && read -r n <"$cache/xkcd.num"
  j=$(xkcd_json "$n") || { printf '%scould not fetch xkcd (X: retry)%s\n' "$RED" "$R"; return 75; }
  img=$(jq -r .img <<<"$j")
  alt=$(jq -r '.alt | gsub("\n"; " ")' <<<"$j")
  title=$(jq -r '"\(.title)  ·  #\(.num)  ·  \(.year)-\(.month)-\(.day)"' <<<"$j")
  tmp=$(mktemp "$cache/xkcd.XXXXXX") || return
  if ! curl -fsS --max-time 15 -o "$tmp" "$img"; then
    rm -f "$tmp"
    printf '%scould not download the comic (X: retry)%s\n' "$RED" "$R"
    return 75
  fi
  center_lines "$tw" "${B}${title}${R}"
  echo
  if ((cell_w > 0)); then
    # Sixel: chafa assumes 10x20 px cells, so scale the box to the real ones. The
    # raster header ("1;1;WIDTH;HEIGHT) gives the image width, used to centre it.
    # The cursor is saved and moved by hand under the image, as terminals disagree
    # on where it ends up (the sixel has its newlines removed)
    sixel=$(chafa -f sixels --size "$((cols * cell_w / 10))x$((XKCD_H * cell_h / 20))" "$tmp" |
      tr -d '\n' | sed $'s/\e\\[?25[lh]//g')
    w=0
    [[ $sixel =~ \"1\;1\;([0-9]+)\; ]] && w=${BASH_REMATCH[1]}
    left=$(((tw - (w + cell_w - 1) / cell_w) / 2))
    ((left < 0)) && left=0
    printf '\e7\e[%dC%s\e8\e[%dB\n' "$left" "$sixel" "$((XKCD_H + 1))"
  else
    # chafa hides/shows the cursor around the image; the dashboard manages it itself
    chafa -f symbols --align mid,top --size "${cols}x${XKCD_H}" "$tmp" |
      sed $'s/\e\\[?25[lh]//g' | sed "s/^/$(printf '%*s' "$MARGIN" '')/"
    echo
  fi
  center_lines "$tw" "$(fold -s -w "$cols" <<<"$alt" | sed "s/ *\$//;s/.*/${DIMC}&${R}/")"
  rm -f "$tmp"
}

sec_xkcd() {
  local n=""
  [[ -r $cache/xkcd.num ]] && read -r n <"$cache/xkcd.num"
  center_lines $((cols + 2 * MARGIN)) "${CYN}xkcd${R}  ${DIMC}(x: random · X: latest)${R}"
  echo
  if ! command -v chafa >/dev/null; then
    printf '%sinstall chafa to draw the comic%s\n' "$DIMC" "$R"
    return
  fi
  XKCD_H=$(($(tput lines 2>/dev/null || echo 40) - 14))
  ((XKCD_H < 10)) && XKCD_H=10
  export XKCD_H
  # Cache per comic and size; the latest one is refreshed hourly
  cached "xkcd_${n:-latest}_${cols}x${XKCD_H}${cell_w:+_s}" 3600 data_xkcd
}

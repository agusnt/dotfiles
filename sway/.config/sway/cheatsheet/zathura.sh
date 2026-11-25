#!/usr/bin/env bash
# zathura key bindings (sourced by cheatsheet.sh; needs sway.sh for `row`).
# zathura has a fixed set of stock bindings, listed here by hand; the `map`
# lines of zathurarc (your own bindings) are parsed and shown first.

if [[ -z ${ZATHURA_CONF:-} ]]; then
  for ZATHURA_CONF in "$dir/../../../../zathura/.config/zathura/zathurarc" "${XDG_CONFIG_HOME:-$HOME/.config}/zathura/zathurarc"; do
    [[ -r $ZATHURA_CONF ]] && break
  done
fi

rows_zathura() {
  local line key cmd s
  local -a tok

  # Custom: map [mode] <key> <command>
  if [[ -r $ZATHURA_CONF ]]; then
    while IFS= read -r line || [[ -n $line ]]; do
      line=${line##+([[:space:]])}
      [[ $line == map[[:space:]]* ]] || continue
      read -ra tok <<<"$line"
      [[ ${tok[1]} == \[*\] ]] && tok=("${tok[0]}" "${tok[@]:2}")
      key=${tok[1]}
      cmd="${tok[*]:2}"
      row "zathurarc" "$key" "$cmd" ""
    done <"$ZATHURA_CONF"
  fi

  s="Navigation"
  row "$s" "j / k" "Scroll down / up" ""
  row "$s" "h / l" "Scroll left / right" ""
  row "$s" "C-d / C-u" "Half page down / up" ""
  row "$s" "Space / S-Space" "Page down / up" ""
  row "$s" "J / K" "Next / previous page" ""
  row "$s" "gg / G" "First / last page (NG = page N)" ""
  row "$s" "C-o / C-i" "Jump back / forward in the jump list" ""
  row "$s" "Tab" "Toggle the index (contents)" ""
  row "$s" "m{x} / '{x}" "Set / go to a mark" ""

  s="Zoom and layout"
  row "$s" "+ / -" "Zoom in / out" ""
  row "$s" "a" "Best fit (whole page)" ""
  row "$s" "s" "Fit width" ""
  row "$s" "d" "Toggle dual-page view" ""
  row "$s" "r" "Rotate 90 degrees" ""
  row "$s" "R" "Reload the document" ""
  row "$s" "F5" "Presentation mode" ""
  row "$s" "F11" "Fullscreen" ""

  s="Search"
  row "$s" "/ / ?" "Search forward / backward" ""
  row "$s" "n / N" "Next / previous match" ""

  s="Colours and interface"
  row "$s" "C-r" "Recolor (dark mode)" "uses the zathurarc recolor colours"
  row "$s" "C-n" "Toggle the status bar" ""
  row "$s" "C-m" "Toggle the input bar" ""
  row "$s" "f" "Show link hints (follow a link)" ""
  row "$s" "F" "Show link hints, display target" ""

  s="Files and commands"
  row "$s" "C-p" "Print the document" ""
  row "$s" "q" "Quit" ""
  row "$s" ":" "Command line" ""
  row "$s" ":bmark / :blist" "Add a bookmark / list bookmarks" ""
  row "$s" ":print / :save" "Print / save a copy of the file" ""
  row "$s" ":set {opt} {val}" "Change an option (e.g. :set recolor true)" ""
  row "$s" ":info" "Show the document metadata" ""
  row "$s" ":exec / :!" "Run a shell command" ""

  s="Mouse"
  row "$s" "Left drag" "Select text" ""
  row "$s" "Middle drag" "Pan the page" ""
  row "$s" "C-scroll" "Zoom" ""
  return 0
}

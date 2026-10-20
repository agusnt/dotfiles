#!/usr/bin/env bash
# tmux key bindings (sourced by cheatsheet.sh; needs sway.sh for `row`).
# Reads the `bind` lines of tmux.conf (sections come from the comment right
# above each group; the description is the command it runs) and adds the
# stock bindings and plugin keys worth remembering.

TMUX_CONF=${TMUX_CONF:-$dir/../tmux.conf}

rows_tmux() {
  local line section="Keys" prefix="C-b" table key rest first tail tag p i
  local cmd joined="" bs='\'
  local -a tok lines=()

  # Join continuations ("\;" is a command separator, a lone trailing "\"
  # continues the line)
  while IFS= read -r line || [[ -n $line ]]; do
    line=${line##+([[:space:]])}
    if [[ -n $joined ]]; then joined+=" $line"; else joined=$line; fi
    if [[ $joined == *[!\;]'\' ]]; then
      joined=${joined%\\}
      continue
    fi
    lines+=("$joined")
    joined=""
  done <"$TMUX_CONF"

  for line in "${lines[@]}"; do
    if [[ $line =~ ^set(-option)?[[:space:]]+-[a-z]*g[a-z]*[[:space:]]+prefix[[:space:]]+([^[:space:]]+) ]]; then
      prefix=${BASH_REMATCH[2]}
    fi
  done
  p="$prefix "

  for line in "${lines[@]}"; do
    # Comment: new section (commented-out code such as "#set ..." is skipped)
    if [[ $line == '# '* ]]; then
      section=${line#\# }
      section=${section%%:*}
      section=${section%% \(*}
      continue
    fi
    [[ $line =~ ^bind(-key)?[[:space:]]+(.*)$ ]] || continue
    rest=${BASH_REMATCH[2]}
    read -ra tok <<<"$rest"

    table=prefix
    i=0
    while [[ ${tok[i]} == -* ]]; do
      if [[ ${tok[i]} == -*T* ]]; then
        table=${tok[i + 1]}
        i=$((i + 1))
      fi
      i=$((i + 1))
    done
    key=${tok[i]}
    if [[ $key == "'\"'" ]]; then key='"'; else key=${key//[\'\"]/}; fi
    cmd="${tok[*]:i+1}"
    cmd=${cmd//"$bs;"/;}
    first=${cmd%%;*}
    tail=""
    [[ $cmd == *';'* ]] && tail=${cmd#*;}
    first=${first%%+([[:space:]])}
    tail=${tail##+([[:space:]])}
    tail=${tail//;/,}; tail=${tail%%+([ ,])}

    case $table in
    prefix) tag="$p" ;;
    root) tag="" ;;
    copy-mode-vi) tag="[copy] " ;;
    *) tag="[$table] " ;;
    esac
    row "$section" "$tag$key" "$first" "$tail"
  done

  local s="Stock bindings (prefix = $prefix)"
  row "$s" "${p}d" "Detach from the session" ""
  row "$s" "${p}n / ${p}p" "Next / previous window" ""
  row "$s" "${p}1..9" "Go to window N" ""
  row "$s" "${p}," "Rename window" ""
  row "$s" "${p}\$" "Rename session" ""
  row "$s" "${p}w" "Window and session tree" ""
  row "$s" "${p}s" "Choose a session" ""
  row "$s" "${p}z" "Zoom / unzoom pane" ""
  row "$s" "${p}x" "Kill pane" ""
  row "$s" "${p}&" "Kill window" ""
  row "$s" "${p}{ / ${p}}" "Swap pane with previous / next" ""
  row "$s" "${p}Space" "Cycle pane layouts" ""
  row "$s" "${p}[" "Enter copy mode (q leaves)" ""
  row "$s" "${p}]" "Paste buffer" ""
  row "$s" "${p}:" "Command prompt" ""
  row "$s" "${p}?" "List all key bindings" ""

  local g="Plugins"
  grep -q "tmux-plugins/tpm" "$TMUX_CONF" && row "$g" "${p}I" "TPM: install plugins" "${p}U updates"
  grep -q "vim-tmux-navigator" "$TMUX_CONF" && row "$g" "C-h/j/k/l" "Move between panes and nvim splits" ""
  if grep -q "tmux-resurrect" "$TMUX_CONF"; then
    row "$g" "${p}C-s" "Resurrect: save the session" ""
    row "$g" "${p}C-r" "Resurrect: restore the session" ""
  fi
  return 0
}

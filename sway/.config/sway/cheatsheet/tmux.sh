#!/usr/bin/env bash
# tmux key bindings (sourced by cheatsheet.sh; needs sway.sh for `row`).
# Reads the `bind` lines of tmux.conf (sections come from the comment right
# above each group; the description is the command it runs) and adds the
# stock bindings and plugin keys worth remembering.

if [[ -z ${TMUX_CONF:-} ]]; then
  for TMUX_CONF in "$dir/../tmux.conf" "$dir/../../../../tmux/.tmux.conf" "$HOME/.tmux.conf"; do
    [[ -r $TMUX_CONF ]] && break
  done
fi

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
  grep -q "tmux-continuum" "$TMUX_CONF" && row "$g" "(auto)" "Continuum: saves every 15 min, restores on start" ""
  grep -q "tmux-yank" "$TMUX_CONF" && row "$g" "[copy] y / Y" "Yank: copy selection to the system clipboard" "Y also pastes it on the prompt"
  if grep -q "tmux-fzf" "$TMUX_CONF"; then
    local fzf_key
    fzf_key=$(sed -n 's/^set-environment -g TMUX_FZF_LAUNCH_KEY "\(.*\)"/\1/p' "$TMUX_CONF")
    row "$g" "${p}${fzf_key:-F}" "tmux-fzf: menu (sessions, windows, panes, commands, keys)" ""
  fi
  if grep -q "tmux-fingers" "$TMUX_CONF"; then
    local fk
    fk=$(sed -n 's/^set -g @fingers-key \(.*\)/\1/p' "$TMUX_CONF")
    row "$g" "${p}${fk:-F}" "Fingers: hints on paths, URLs, hashes, IPs" "letter copies, SHIFT+letter pastes"
  fi
  if grep -q "tmux-sessionx" "$TMUX_CONF"; then
    local sk
    sk=$(sed -n "s/^set -g @sessionx-bind '\(.*\)'/\1/p" "$TMUX_CONF")
    row "$g" "${p}${sk:-O}" "SessionX: fzf session manager with preview" "zoxide to create new sessions"
  fi
  if grep -q "tmux-open" "$TMUX_CONF"; then
    row "$g" "[copy] o" "Open selection (file, URL)" ""
    row "$g" "[copy] C-o" "Open selection in \$EDITOR" ""
    row "$g" "[copy] S" "Search selection on the web" ""
  fi
  grep -q "tmux-prefix-highlight" "$TMUX_CONF" && row "$g" "(bar)" "Prefix highlight: shows when prefix or copy mode is active" ""
  return 0
}

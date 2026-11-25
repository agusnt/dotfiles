# Show the zsh vi mode in the tmux status bar (pane option @vimode, see .tmux.conf)
if [[ -n $TMUX ]]; then
  autoload -Uz add-zsh-hook
  _tmux_vimode() { command tmux set-option -p -t "$TMUX_PANE" @vimode "$1" \; refresh-client -S 2>/dev/null }
  function zvm_after_select_vi_mode() {
    case $ZVM_MODE in
      $ZVM_MODE_NORMAL) _tmux_vimode NORMAL ;;
      $ZVM_MODE_INSERT) _tmux_vimode INSERT ;;
      $ZVM_MODE_VISUAL|$ZVM_MODE_VISUAL_LINE) _tmux_vimode VISUAL ;;
      $ZVM_MODE_REPLACE) _tmux_vimode REPLACE ;;
    esac
  }
  # Hide it while a command (nvim, ssh...) owns the pane
  add-zsh-hook preexec _tmux_vimode_clear
  _tmux_vimode_clear() { _tmux_vimode "" }
fi

# Inside a devcontainer tmux runs on the host and only sees `devcontainer exec`
# (node). Report the running app as the terminal title so the tmux window name
# can show it instead (read from #{pane_title} by tmux-nerd-font-window-name).
if [[ -z $TMUX && ( -f /.dockerenv || -n $REMOTE_CONTAINERS ) ]]; then
  autoload -Uz add-zsh-hook
  typeset -A _ct_icons=(claude $'\U000F06A9' nvim $'\UE6AE' vim $'\UE62B' git $'\UE702'
    python $'\UE73C' python3 $'\UE73C' node $'\UE718' zsh $'\UF489')
  _ct_title() { printf "\e]2;%s%s\a" "${_ct_icons[$1]:+$_ct_icons[$1] }" "${${1/#claude/Claude}}" }
  _ct_title_preexec() { local c=${${(z)1}[1]}; _ct_title "${c:t}" }
  _ct_title_precmd() { _ct_title zsh }
  # Claude Code would overwrite the title with its session summary
  export CLAUDE_CODE_DISABLE_TERMINAL_TITLE=1
  add-zsh-hook preexec _ct_title_preexec
  add-zsh-hook precmd _ct_title_precmd
fi


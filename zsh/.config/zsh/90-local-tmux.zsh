# Claude
# Secrets (CLAUDE_CODE_OAUTH_TOKEN, etc.) live in ~/.zshrc.local, outside git
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

###############################################################################
# tmux: every interactive terminal lands in the "Default" session (created if missing)
###############################################################################
# Skipped inside tmux, over ssh, without a terminal (scp, ssh host cmd), in editors'
# built-in terminals (nvim, VS Code) or with NOTMUX=1
if [[ -o interactive && -t 0 && -t 1 && -z "$TMUX" && -z "$NOTMUX" && -z "$SSH_CONNECTION" && -z "$SSH_TTY" \
      && -z "$NVIM" && "$TERM_PROGRAM" != vscode ]] && command -v tmux >/dev/null; then
  exec tmux new-session -A -s Default
fi

###############################################################################
# tmux tips on every interactive shell (full cheat sheet: prefix+/ in tmux)
###############################################################################
# Print a prompt-formatted line centered in the terminal
_center_print() {
  setopt localoptions extendedglob
  local line=${(%)1}
  local plain=${line//$'\e'\[[0-9;]#m/}
  local pad=$(( (COLUMNS - ${#plain}) / 2 ))
  (( pad < 0 )) && pad=0
  printf '%*s%s\n' $pad '' "$line"
}
if [[ -o interactive && -t 1 && -z "$NOTIPS" ]]; then
  if [[ -n "$TMUX" ]]; then
    _center_print "%F{8}tmux (prefix=C-b)%f  %F{3}d%f detach  %F{3}c%f new window  %F{3}%%%f/%F{3}\"%f split  %F{3}h j k l%f move  %F{3}z%f zoom  %F{3}x%f close  %F{3}C%f center  %F{3}o%f sessions  %F{3}/%f help"
    _center_print "%F{8}new session:%f %F{3}prefix :%f then %F{3}new -s name%f   %F{8}(from a shell: %F{3}tmux new -s name%F{8})%f"
  elif command -v tmux >/dev/null; then
    _center_print "%F{8}tmux:%f %F{3}tmux new -A -s Default%f attach/create   %F{3}tmux new -s name%f new session   %F{3}tmux ls%f list"
  fi
fi

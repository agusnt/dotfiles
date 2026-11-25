###############################################################################
# Tmux config
###############################################################################

autoload -Uz vcs_info
precmd() { vcs_info }

setopt PROMPT_SUBST

# Is this session an ssh?
function prompt_ssh_indicator() {
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    echo "%F{green}[󰌘 SSH]%F{red}[]%F{blue}[]%f[@%m]"
  else
    echo "%F{red}[]%f"
  fi
}

NEWLINE=$'\n'
PROMPT='%B$(prompt_ssh_indicator)%b[%2d]%b${vcs_info_msg_0_}${NEWLINE}%F{green}%b%f '

zstyle ':vcs_info:git:*' formats '%F{yellow}[ %b]'


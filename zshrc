zmodload zsh/zprof
###############################################################################
# Path
###############################################################################
export PATH=/home/agus/.local/bin:/usr/local/bin/:/usr/sbin/:$PATH
export EDITOR=nvim

###############################################################################
# Plugins
###############################################################################
if [ ! -d ~/.zsh ]; then
    mkdir -p ~/.zsh
fi

# Antigen as plugin management
if [ ! -f ~/.zsh/antigen.zsh ]; then
    curl -L git.io/antigen > ~/.zsh/antigen.zsh
fi

source ~/.zsh/antigen.zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle unixorn/fzf-zsh-plugin@main # Autocomplete
antigen bundle Aloxaf/fzf-tab # Suggestions
antigen bundle jeffreytse/zsh-vi-mode # Vi-mode
antigen bundle ael-code/zsh-colored-man-pages # Colored man pages
antigen bundle mdumitru/fancy-ctrl-z # Fancy ctrl z
antigen bundle zpm-zsh/colors

if [[ "$OSTYPE" == "darwin"* ]]; then
    antigen bundle osx
fi

antigen theme https://github.com/sbugzu/gruvbox-zsh gruvbox

antigen apply # We are ready

###############################################################################
# Theme
###############################################################################
ZSH_THEME="gruvbox"
SOLARIZED_THEME="dark"

###############################################################################
# History 
###############################################################################
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

###############################################################################
# Load extra stuff
###############################################################################

source ~/.aliases

###############################################################################
# Tmux config
###############################################################################

autoload -Uz vcs_info
precmd() { vcs_info }

setopt PROMPT_SUBST

NEWLINE=$'\n'
PROMPT='%B[@%m]%b[%2d]%b${vcs_info_msg_0_}${NEWLINE}%F{green}%B %b%f'

zstyle ':vcs_info:git:*' formats '%F{yellow}[ %b]'

###############################################################################
# Yazi stuff
###############################################################################
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

path=('/home/agus/.juliaup/bin' $path)
export PATH
export PATH=~/.npm-global/bin:$PATH

###############################################################################
# Globar Vars
###############################################################################
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export JAVA_HOME=/usr/

###############################################################################
# SSH stuff
###############################################################################
if [ -z "$SSH_AUTH_SOCK" ]; then
   eval "$(ssh-agent -s)" >/dev/null
fi

# Not ask for password for 30 min
function _ssh_auto_add() {
  # Uncomment if the key pass has password
  #if ! ssh-add -l | grep -q "$(ssh-keygen -lf ~/.ssh/id_ed25519 | awk '{print $2}')"; then
  #  ssh-add -t 30m ~/.ssh/id_ed25519
  #fi
  command "$@"
}
function ssh() { _ssh_auto_add ssh "$@"; }
function rsync() { _ssh_auto_add rsync "$@"; }

. "$HOME/.cargo/env"

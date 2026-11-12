zmodload zsh/zprof
###############################################################################
# Path
###############################################################################
export PATH=~/.local/bin:/usr/local/bin/:~/.npm-global/bin:/sbin/:~/.cargo/bin:$PATH
export EDITOR=nvim
# Change GO directory
export GOPATH=$HOME/.local/share/go

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
antigen bundle zsh-users/zsh-completions # More completions
antigen bundle zsh-users/zsh-history-substring-search # Up/down search history by prefix
antigen bundle MichaelAquilina/zsh-you-should-use # Reminds you of aliases
antigen bundle hlissner/zsh-autopair # Close quotes and brackets
antigen bundle wfxr/forgit # git + fzf (ga, glo, gd, gss...)
antigen bundle ael-code/zsh-colored-man-pages # Colored man pages
antigen bundle mdumitru/fancy-ctrl-z # Fancy ctrl z
antigen bundle zpm-zsh/colors
antigen bundle MichaelAquilina/zsh-autoswitch-virtualenv

if [[ "$OSTYPE" == "darwin"* ]]; then
    antigen bundle osx
fi

antigen theme https://github.com/sbugzu/gruvbox-zsh gruvbox

antigen apply # We are ready

# zsh-vi-mode resets the keymaps on startup, so everything bound to keys goes here
function zvm_after_init() {
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey '^[OA' history-substring-search-up
  bindkey '^[OB' history-substring-search-down
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
  (( $+functions[autopair-init] )) && autopair-init
  # atuin takes over Ctrl-R (and keeps the arrow keys for substring search)
  command -v atuin >/dev/null && eval "$(atuin init zsh --disable-up-arrow)"
}

# z / zi: jump to frequently used directories (also used by tmux-sessionx)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

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

# pack / unpack / unpack --listed live in ~/.zsh_archive
[ -f ~/.zsh_archive ] && source ~/.zsh_archive

###############################################################################
# Convert files
###############################################################################
fileConvert () {
  case $1 in
    *.heic)
      case $2 in
        *.jpg) heif-convert -q 100 $1 $2 ;;
        *)   echo "don't know how to convert to $2..." ;;
      esac
      ;;
    *)       echo "don't know how to convert from $1..." ;;
  esac
}

TMPDIR=/tmp
TMP=$TMPDIR
TEMP=$TMPDIR

export TMPDIR TMP TEMP

###############################################################################
# Like Bash
###############################################################################
setopt BASH_REMATCH
setopt BRACE_CCL
setopt nonomatch
autoload -Uz braceccl

# . "$HOME/.cargo/env"

# Latex stuff
export TEXINPUTS=".:$HOME/Templates/latex//:$TEXINPUTS"

# Cluadio
# Secrets (CLAUDE_CODE_OAUTH_TOKEN, etc.) live in ~/.zshrc.local, outside git
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

###############################################################################
# tmux: every interactive terminal lands in the "Default" session (created if missing)
###############################################################################
# Skipped inside tmux, without a terminal (scp, ssh host cmd), in editors'
# built-in terminals (nvim, VS Code) or with NOTMUX=1
if [[ -o interactive && -t 0 && -t 1 && -z "$TMUX" && -z "$NOTMUX" \
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

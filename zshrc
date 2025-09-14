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
antigen bundle MichaelAquilina/zsh-autoswitch-virtualenv

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
PROMPT='%B[@%m]%b[%2d]%b${vcs_info_msg_0_}${NEWLINE}%F{green}%B %b%f'

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

###############################################################################
# Pack and Unpack file
###############################################################################
unpack () {
  if [ -f $1 ] ; then
    case $1 in
    *.tar.bz2) tar xvjf $1    ;;
    *.tar.gz)  tar xvzf $1    ;;
    *.tar.xz)  tar xf $1      ;;
    *.bz2)     bunzip2 $1     ;;
    *.rar)     unrar x $1     ;;
    *.gz)      gunzip $1      ;;
    *.tar)     tar xvf $1     ;;
    *.tbz2)    tar xvjf $1    ;;
    *.tgz)     tar xvzf $1    ;;
    *.zip)     unzip $1       ;;
    *.Z)       uncompress $1  ;;
    *.7z)      7z x $1        ;;
    *)         echo "don't know how to extract '$1'..." ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

pack () {
  case $1 in
  *.tar.bz2) tar -cvjSf $1 ${@:2} ;;
  *.tar.gz)  tar -czvf $1 ${@:2}  ;;
  *.tar.xz)  tar cfJ $1 ${@:2}   ;;
  *.bz2)     bzip2 $1             ;;
  *.rar)     rar a $1 ${@:2}      ;;
  *.gz)      gzip $1              ;;
  *.tar)     tar -cvf $1 ${@:2}   ;;
  *.tbz2)    tar -cjvSf $1 ${@:2} ;;
  *.tgz)     tar -czvf $1 ${@:2}  ;;
  *.zip)     zip -r $1 ${@:2}     ;;
  *.Z)       compress $1          ;;
  *.7z)      7z a $1              ;;
  *)         echo "don't know how to compress $1..." ;;
  esac
}

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

###############################################################################
# Like Bash
###############################################################################
setopt BASH_REMATCH
setopt BRACE_CCL
setopt nonomatch
autoload -Uz braceccl

. "$HOME/.cargo/env"

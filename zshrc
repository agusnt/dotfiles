# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

###############################################################################
# Path
###############################################################################
export PATH=~/Documents/bin:/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/bin:~/.cargo/bin/:$PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

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

antigen bundle git # Git plugin
antigen bundle zsh-users/zsh-syntax-highlighting # Syntax highlight
antigen bundle marlonrichert/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle unixorn/fzf-zsh-plugin@main # Autocomplete
antigen bundle Aloxaf/fzf-tab # Suggestions
antigen bundle ael-code/zsh-colored-man-pages # Colored man pages
antigen bundle mdumitru/fancy-ctrl-z # Fancy ctrl z

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
# Load extra stuff
###############################################################################

source ~/.aliases
source ~/.aliases_cmd

###############################################################################
# Tmux config
###############################################################################

if [ "$TMUX" = "" ]; then tmux attach -d || tmux; fi

autoload -Uz vcs_info
precmd() { vcs_info }

setopt PROMPT_SUBST

NEWLINE=$'\n'
PROMPT='[%2d]%b${vcs_info_msg_0_}${NEWLINE}%F{green}%B %b'

zstyle ':vcs_info:git:*' formats '%F{yellow}[ %b]'

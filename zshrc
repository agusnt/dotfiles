###############################################################################
# Path
###############################################################################

HOMEBREW_PREFIX=$(brew --prefix)
export PATH=~/bin:$HOMEBREW_PREFIX/bin:/usr/local/bin:$PATH
#export PATH=/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/TeX/texbin:/opt/homebrew/bin:/opt/homebrew/sbin:/Applications/kitty.app/Contents/MacOS:/Users/agus/Documents/bin
export ZSH="$HOME/.oh-my-zsh"

###############################################################################
# Themes
#
# Install gruvbox
#
# curl -L https://raw.githubusercontent.com/sbugzu/gruvbox-zsh/master/gruvbox.zsh-theme > ~/.oh-my-zsh/custom/themes/gruvbox.zsh-theme
###############################################################################

ZSH_THEME="gruvbox"
SOLARIZED_THEME="dark"

###############################################################################
# Load extra stuff
###############################################################################

source $ZSH/oh-my-zsh.sh
source ~/.aliases

###############################################################################
# Tmux config
###############################################################################

if [ "$TMUX" = "" ]; then tmux attach -d || tmux; fi

###############################################################################
# Plugins
###############################################################################

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust
### End by Zinit's installer

# Install plugins
# bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
#
# zinit self-update
#

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light unixorn/fzf-zsh-plugin
zinit light Aloxaf/fzf-tab

plugins=(copyfile git)

PROMPT="%B>>%b "
precmd() { print "" }

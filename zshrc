###############################################################################
# Path
###############################################################################

HOMEBREW_PREFIX=$(brew --prefix)
export PATH=/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/TeX/texbin:/opt/homebrew/bin:/opt/homebrew/sbin:/Applications/kitty.app/Contents/MacOS:/Users/agus/Documents/bin
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
# Plugins
###############################################################################

# Install plugins
# git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git source zsh-snap/install.zsh
#

[[ -f ~/.config/znap/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/.config/znap/zsh-snap

source ~/.config/znap/zsh-snap/znap.zsh

znap prompt sindresorhus/pure

znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting

plugins=(copyfile git)

###############################################################################
# Load extra stuff
###############################################################################

source $ZSH/oh-my-zsh.sh
source ~/.aliases

###############################################################################
# Tmux config
###############################################################################

if [ "$TMUX" = "" ]; then tmux attach -d || tmux; fi

eval "$(starship init zsh)"

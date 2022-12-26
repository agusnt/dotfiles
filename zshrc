###############################################################################
# Path
###############################################################################

HOMEBREW_PREFIX=$(brew --prefix)
export PATH=~/bin:$HOMEBREW_PREFIX/bin:/usr/local/bin:$PATH
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
#source ~/.aliases

###############################################################################
# Tmux config
###############################################################################

if [ "$TMUX" = "" ]; then tmux attach -d || tmux; fi

###############################################################################
# Plugins
###############################################################################

### Added by Zinit's installer
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

eval "$(starship init zsh)"

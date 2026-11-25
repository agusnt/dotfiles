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

# Needed before the first prompt: keymaps, completion and fzf
antigen bundle romkatv/zsh-defer # Defer slow plugins until the prompt is shown
antigen bundle unixorn/fzf-zsh-plugin@main # Autocomplete
antigen bundle Aloxaf/fzf-tab # Suggestions
antigen bundle jeffreytse/zsh-vi-mode # Vi-mode
antigen bundle zsh-users/zsh-completions # More completions
antigen bundle hlissner/zsh-autopair # Close quotes and brackets

if [[ "$OSTYPE" == "darwin"* ]]; then
    antigen bundle osx
fi

antigen theme https://github.com/sbugzu/gruvbox-zsh gruvbox

antigen apply # We are ready

# Everything else loads after the first prompt, in this order (zsh-defer queue).
# antigen only handles what the first prompt needs; these are cloned into
# ~/.zsh/plugins on first use and sourced directly.
_defer_plugin() {  # _defer_plugin user/repo
  local dir=~/.zsh/plugins/${1:t} f
  [[ -d $dir ]] || command git clone --depth 1 -q "https://github.com/$1" "$dir" 2>/dev/null || return
  f=($dir/*.plugin.zsh(N[1]) $dir/*.zsh(N[1]))
  [[ -n $f ]] && source $f[1]
}
for _p in \
  zsh-users/zsh-autosuggestions \
  MichaelAquilina/zsh-you-should-use \
  ael-code/zsh-colored-man-pages \
  mdumitru/fancy-ctrl-z \
  MichaelAquilina/zsh-autoswitch-virtualenv \
  wfxr/forgit \
  MichaelAquilina/zsh-auto-notify \
  zsh-users/zsh-syntax-highlighting   # keep last: it wraps the widgets defined above
do
  zsh-defer _defer_plugin $_p
done
unset _p

export AUTO_NOTIFY_THRESHOLD=60
export AUTO_NOTIFY_IGNORE=(nvim vim tmux ssh yazi y less man htop btop claude lazygit fzf)
# replace the plugin's sender (defined once it loads) so notifications go out as low urgency
# (_auto_notify_send is the plugin's precmd hook: the sender is _auto_notify_message)
_auto_notify_low() {  # command elapsed exit_code
  local urgency=low
  (( $3 != 0 )) && urgency=critical
  notify-send -u $urgency -a zsh "\"$1\" Completed" "Total time: $2 seconds"$'\n'"Exit code: $3"
}
zsh-defer eval '_auto_notify_message() { _auto_notify_low "$@" }'

# zsh-vi-mode resets the keymaps on startup, so everything bound to keys goes here
function zvm_after_init() {
  (( $+functions[autopair-init] )) && autopair-init
  # atuin takes over Ctrl-R (the arrow keys keep the default history behaviour)
  command -v atuin >/dev/null && eval "$(atuin init zsh --disable-up-arrow)"
}

# z / zi: jump to frequently used directories (also used by tmux-sessionx)
command -v zoxide >/dev/null && zsh-defer eval '$(zoxide init zsh)'


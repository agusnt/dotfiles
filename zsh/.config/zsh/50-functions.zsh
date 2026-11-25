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


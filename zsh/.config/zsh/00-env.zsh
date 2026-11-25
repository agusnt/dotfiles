###############################################################################
# Path
###############################################################################
export PATH=~/.local/bin:/usr/local/bin/:~/.npm-global/bin:/sbin/:~/.cargo/bin:$PATH
export EDITOR=nvim
# Change GO directory
export GOPATH=$HOME/.local/share/go

###############################################################################
# Globar Vars
###############################################################################
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=gtk3
export JAVA_HOME=/usr/

# eza's defaults are bold almost everywhere: reset them and redefine without bold
export EZA_COLORS="reset:di=34:ex=32:ln=36:or=31:ur=33:uw=31:ux=32:ue=32:uu=33:gu=33:un=33:gn=33:sn=32:sb=32:da=34:gm=33:ga=32:gd=31:gv=36:gt=35:lc=35:xa=36"


TMPDIR=/tmp
TMP=$TMPDIR
TEMP=$TMPDIR

export TMPDIR TMP TEMP

# Latex stuff
export TEXINPUTS=".:$HOME/Templates/latex//:$TEXINPUTS"


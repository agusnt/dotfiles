#!/usr/bin/env bash
# Lock the screen. The only place with the swaylock options (used by the
# key binding, swayidle and lid.sh). Does nothing if already locked.

pgrep -x swaylock >/dev/null && exit 0

bg=${LOCK_BG:-/usr/share/images/desktop-base/desktop-background}
if [ -r "$bg" ]; then
  img=(-i "$bg" -s fill)
else
  img=(-c 282828)
fi

swaylock -f "${img[@]}" --ignore-empty-password --show-failed-attempts || exit

# swaylock never emits the logind Unlock signal, so swayidle's "unlock" event
# does not fire. Run the post-unlock hook here once swaylock exits. Detached,
# so callers (swayidle before-sleep, lid.sh) are not blocked until unlock.
net=~/.local/bin/network.sh
if [ -x "$net" ]; then
  setsid -f bash -c 'while pgrep -x swaylock >/dev/null; do sleep 1; done; exec "$1"' _ "$net" >/dev/null 2>&1
fi

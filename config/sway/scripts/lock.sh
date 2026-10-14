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

exec swaylock -f "${img[@]}" --ignore-empty-password --show-failed-attempts

#!/bin/sh
# Start gammastep with lat/lon derived from the system timezone
# (zone.tab centroid of the zone's main city; good enough for sunrise/sunset).
command -v gammastep >/dev/null || exit 0

tz=$(timedatectl show -p Timezone --value 2>/dev/null)
[ -n "$tz" ] || tz=$(readlink /etc/localtime | sed 's|.*/zoneinfo/||')

loc=$(awk -F'\t' -v tz="$tz" '$3 == tz && $1 !~ /^#/ {
  c = $2
  # ±DDMM[SS]±DDDMM[SS]
  i = index(substr(c, 2), "+"); j = index(substr(c, 2), "-")
  k = (i && (!j || i < j)) ? i : j
  la = substr(c, 1, k); lo = substr(c, k + 1)
  sl = substr(la, 1, 1) == "-" ? -1 : 1; la = substr(la, 2)
  so = substr(lo, 1, 1) == "-" ? -1 : 1; lo = substr(lo, 2)
  d = (length(la) == 4) ? 2 : 2
  lat = substr(la, 1, 2) + substr(la, 3, 2) / 60 + (length(la) > 4 ? substr(la, 5, 2) / 3600 : 0)
  lon = substr(lo, 1, 3) + substr(lo, 4, 2) / 60 + (length(lo) > 5 ? substr(lo, 6, 2) / 3600 : 0)
  printf "%.2f:%.2f", sl * lat, so * lon
  exit
}' /usr/share/zoneinfo/zone.tab)

[ -n "$loc" ] && exec gammastep -l "$loc"
exec gammastep   # fallback: config.ini / geoclue

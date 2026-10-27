#!/usr/bin/env bash
# Settings shared by bar.sh and dashboard.sh (sourced).

# PATH: sway does not read ~/.zshrc (interactive shells only), so tools installed in
# the usual per-user directories (pipx, cargo...) would look missing.
# Append the ones that exist and are not on PATH yet.
for _d in "$HOME/.local/bin" "$HOME/bin" "$HOME/.cargo/bin" \
  /usr/local/bin; do
  [[ -d $_d && :$PATH: != *":$_d:"* ]] && PATH+=":$_d"
done
unset _d
export PATH

# City for the weather. The default can be overridden at runtime from the
# dashboard (press "c") or with `dashboard.sh city NAME`; that choice is saved
# in CITY_FILE and wins over the default below.
CITY=Zaragoza
CITIES=(Zaragoza Madrid Barcelona Valencia Sevilla) # shortcuts in the city menu (max. 9)
CITY_FILE=${XDG_STATE_HOME:-$HOME/.local/state}/sway-dashboard-city
[[ -r $CITY_FILE ]] && read -r CITY <"$CITY_FILE"

# Investments shown in the dashboard. One per line: Yahoo Finance symbol, optional
# units held, optional name. Kept out of git (see .gitignore).
INVEST_FILE=${XDG_CONFIG_HOME:-$HOME/.config}/sway/investments.conf

# Status bar thresholds. A module is only shown once its *_SHOW value is reached.
CPU_SHOW=50  # CPU %
RAM_SHOW=70  # RAM %
TEMP_SHOW=70 # °C
DISK_SHOW=85 # disk usage % (/ and $HOME)
# Icon colours: yellow from *_WARN, red from *_CRIT (the block itself turns red
# at *_CRIT for CPU, RAM, temperature and disk)
LOAD_WARN=70 # CPU, RAM and disk %
LOAD_CRIT=90
TEMP_WARN=70 # °C
TEMP_CRIT=80
BAT_WARN=30 # battery %: yellow icon at or below
BAT_CRIT=15 # red icon at or below; also triggers the "Low battery" notification
SIG_WARN=30 # WiFi signal %: yellow icon at or below
SIG_CRIT=10 # red icon at or below

# Last successful backup: mtime of a stamp file that a borgmatic after-backup
# hook has to touch. It is reported as stale once it is older than BACKUP_WARN_H.
BACKUP_STAMP=${XDG_STATE_HOME:-$HOME/.local/state}/backup-last-success
BACKUP_WARN_H=48

# Units listed in the dashboard "Services" section. System units by default;
# prefix with "user:" for systemd --user units.
DASH_SERVICES=(
  NetworkManager.service
  bluetooth.service
  systemd-homed.service
  user:backup.timer
  # user:syncthing.service
)

# Optional bar pieces (per machine; override in ~/.config/sway/local.sh if needed)
BAR_UPDATES=0 # pending Debian updates counter
WG_IFACE=nas  # WireGuard interface to watch; empty hides the icon
[[ -r ${XDG_CONFIG_HOME:-$HOME/.config}/sway/local.sh ]] && . "${XDG_CONFIG_HOME:-$HOME/.config}/sway/local.sh"

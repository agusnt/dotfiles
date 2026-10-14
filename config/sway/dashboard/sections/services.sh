#!/usr/bin/env bash
# Services section: state of the units listed in DASH_SERVICES (sourced by dashboard.sh).

# print_states SCOPE_FLAG UNIT...: one coloured line per unit
print_states() {
  local flag=$1 u s c i
  shift
  local -a states
  (($# > 0)) || return
  mapfile -t states < <(systemctl $flag is-active "$@" 2>/dev/null)
  i=0
  for u in "$@"; do
    s=${states[i]:-unknown}
    case $s in
    active) c=$GRN ;;
    failed) c=$RED ;;
    *) c=$DIMC ;;
    esac
    printf '%-28s %s%s%s\n' "$u" "$c" "$s" "$R"
    i=$((i + 1))
  done
}

data_services() {
  local u
  local -a sys=() usr=()
  for u in "${DASH_SERVICES[@]}"; do
    if [[ $u == user:* ]]; then usr+=("${u#user:}"); else sys+=("$u"); fi
  done
  print_states "" "${sys[@]}"
  print_states "--user" "${usr[@]}"
}

sec_services() {
  title "Services"
  if ((${#DASH_SERVICES[@]})); then
    cached services 10 data_services
  else
    printf '%sset DASH_SERVICES in lib/settings.sh%s\n' "$DIMC" "$R"
  fi
}

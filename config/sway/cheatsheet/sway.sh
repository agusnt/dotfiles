#!/usr/bin/env bash
# Sway key bindings parser (sourced by cheatsheet.sh).
# Reads sway/config (following its includes under sway/) and prints one record per binding:
#   SECTION US KEYS US DESCRIPTION US DETAIL      (US = unit separator, \x1f)
# Sections come from the banner comments (a comment between two separator
# lines); the description is the comment right above the binding, if any.

SWAY_CONFIG=${SWAY_CONFIG:-$dir/../config}

# sway_config_lines: print SWAY_CONFIG, replacing each "include ~/.config/sway/PATH"
# line (globs allowed) with the contents of those files, in sway's order
sway_config_lines() {
  local line f
  local root=${SWAY_CONFIG%/*}
  while IFS= read -r line || [[ -n $line ]]; do
    if [[ $line =~ ^include[[:space:]]+~/\.config/sway/(.+)$ ]]; then
      for f in "$root"/${BASH_REMATCH[1]}; do
        [[ -f $f ]] && { cat "$f"; echo; }
      done
    else
      printf '%s\n' "$line"
    fi
  done <"$SWAY_CONFIG"
}

# row SECTION KEYS DESCRIPTION DETAIL: print one record
row() { printf '%s\x1f%s\x1f%s\x1f%s\n' "$1" "$2" "$3" "$4"; }

rows_sway() {
  local line text rest keys cmd t out name pass ws
  local note="" section="Bindings" saved="" pending="" after_sep=0 i
  local -a tok ctok names=()
  local -A var=()

  while IFS= read -r line || [[ -n $line ]]; do
    line=${line##+([[:space:]])}
    line=${line%%+([[:space:]])}

    # A blank line ends the current note and any half-read banner
    if [[ -z $line ]]; then
      note="" pending="" after_sep=0
      continue
    fi

    # Banner separator ("####" or "# ----"): the comment between two of them
    # is a section title
    if [[ $line =~ ^#[[:space:]]*[-#]{8,}$ ]]; then
      if [[ -n $pending ]]; then
        # Keep the title short: drop a trailing "(details)" and the final colon
        section=${pending%% (*}
        section=${section%:}
        pending="" after_sep=0 note=""
      else
        after_sep=1
      fi
      continue
    fi

    if [[ $line == '#'* ]]; then
      text=${line##+(#)}
      text=${text##+([[:space:]])}
      # Commented-out configuration is not documentation
      [[ $text =~ ^(bind|set[[:space:]]|for_window|exec|gaps|default_|client\.|output|input|include|position) ]] && continue
      if ((after_sep)); then
        pending=$text after_sep=0
      else
        note=$text
      fi
      continue
    fi
    after_sep=0 pending=""

    # Variables: set $name value
    if [[ $line =~ ^set[[:space:]]+(\$[A-Za-z0-9_]+)[[:space:]]+(.*)$ ]]; then
      var[${BASH_REMATCH[1]}]=${BASH_REMATCH[2]%%+([[:space:]])}
      names=()
      continue
    fi

    # Binding modes: bindings inside get their own section
    if [[ $line =~ ^mode[[:space:]]+\"?([^\"{]*[^\"{[:space:]])\"?[[:space:]]*\{$ ]]; then
      saved=$section
      section="Mode: ${BASH_REMATCH[1]}"
      continue
    fi
    if [[ $line == '}' ]]; then
      [[ -n $saved ]] && section=$saved
      saved=""
      continue
    fi

    [[ $line =~ ^(bindsym|bindcode|bindswitch)[[:space:]]+(.*)$ ]] || continue
    rest=${BASH_REMATCH[2]}
    local kind=${BASH_REMATCH[1]}

    read -ra tok <<<"$rest"
    i=0
    while [[ ${tok[i]:-} == --* ]]; do i=$((i + 1)); done
    keys=${tok[i]:-}
    cmd=${tok[*]:i+1}

    # Expand variables longest name first; twice, as values can use other variables
    if ((${#names[@]} == 0)); then
      mapfile -t names < <(printf '%s\n' "${!var[@]}" | awk '{print length($0), $0}' | sort -rn | cut -d' ' -f2)
    fi
    for pass in 1 2; do
      for name in "${names[@]}"; do
        keys=${keys//"$name"/${var[$name]}}
        cmd=${cmd//"$name"/${var[$name]}}
      done
    done
    keys=${keys//Mod4/Super}
    keys=${keys//Mod1/Alt}
    [[ $kind == bindcode ]] && keys="code $keys"

    # Workspaces 1-9 collapse into a single row each
    if [[ $cmd =~ ^workspace[[:space:]]number[[:space:]]([0-9]+)$ ]]; then
      ws=${BASH_REMATCH[1]}
      [[ $ws == 1 ]] && row "$section" "${keys%1}1-0" "Go to workspace N" ""
      continue
    fi
    if [[ $cmd =~ ^move[[:space:]]container[[:space:]]to[[:space:]]workspace[[:space:]]number[[:space:]]([0-9]+)$ ]]; then
      ws=${BASH_REMATCH[1]}
      [[ $ws == 1 ]] && row "$section" "${keys%1}1-0" "Move container to workspace N" ""
      continue
    fi

    # Shorten script paths to their basename and drop the leading "exec"
    read -ra ctok <<<"$cmd"
    out=""
    for t in "${ctok[@]}"; do
      [[ $t == */* && $t != *'['* ]] && t=${t##*/}
      out+=" $t"
    done
    cmd=${out# }
    cmd=${cmd#exec }

    # Inside a mode the comments describe the whole block, not one key
    [[ $section == Mode:* ]] && note=""

    if [[ -n $note ]]; then
      row "$section" "$keys" "$note" "$cmd"
    else
      row "$section" "$keys" "$cmd" ""
    fi
  done < <(sway_config_lines)
}

#!/usr/bin/env bash
# Neovim key bindings parser (sourced by cheatsheet.sh; needs sway.sh for `row`).
# Reads nvim/lua/config/keymap.lua (map()/lmap() calls) and the blink.cmp
# keymap in nvim/lua/plugins/cmp.lua. Sections come from the standalone
# `-- Title` comments in keymap.lua; the description comes from `desc = "..."`,
# else from the trailing `-- comment`, else from the <cmd> the key runs.

# $dir is symlink-resolved (it may live in the dotfiles repo), so fall back to ~/.config
if [[ -z ${NVIM_DIR:-} ]]; then
  for NVIM_DIR in "$dir/../../nvim" "$dir/../../../../nvim/.config/nvim" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"; do
    [[ -r $NVIM_DIR/lua/config/keymap.lua ]] && break
  done
fi

rows_nvim() {
  local line text args mode lhs desc tag section="Keymaps" leader='\' re_q re_d q="'"
  local f=$NVIM_DIR/lua/config

  # <leader> is shown as its real key
  if [[ $(<"$f/vim.lua") =~ mapleader[[:space:]]*=[[:space:]]*\"(.)\" ]]; then leader=${BASH_REMATCH[1]}; fi

  re_q="^[[:space:]]*(\"([^\"]+)\"|${q}([^${q}]+)${q})"
  re_d="desc[[:space:]]*=[[:space:]]*(\"([^\"]*)\"|${q}([^${q}]*)${q})"

  while IFS= read -r line || [[ -n $line ]]; do
    line=${line##+([[:space:]])}

    # Standalone comment: a new section (ignore file header and disabled code)
    if [[ $line == '-- '* ]]; then
      text=${line#-- }
      [[ $text == *@* || $text == map* || $text == local* ]] || section=$text
      continue
    fi

    [[ $line =~ ^l?map\((.*)$ ]] || continue
    args=${BASH_REMATCH[1]}

    # Modes: "n" or { "n", "v" }
    if [[ $args == '{'* ]]; then
      mode=${args%%\}*}
      mode=${mode#\{}
      args=${args#*\}}
      args=${args#,}
    else
      mode=${args%%,*}
      args=${args#*,}
    fi
    mode=${mode//[\"\' ]/}

    [[ $args =~ $re_q ]] || continue # dynamic left-hand side: nothing to show
    lhs=${BASH_REMATCH[2]}${BASH_REMATCH[3]}
    lhs=${lhs//<leader>/$leader}

    desc=""
    if [[ $line =~ $re_d ]]; then
      desc=${BASH_REMATCH[2]}${BASH_REMATCH[3]}
    elif [[ $line =~ [[:space:]]--[[:space:]]+(.*)$ ]]; then
      desc=${BASH_REMATCH[1]}
    elif [[ $args =~ \<cmd\>([^\<]+)\<[cC][rR]\> ]]; then
      desc=":${BASH_REMATCH[1]}"
    fi
    [[ -n $desc ]] || desc="(no description)"

    tag=""
    [[ $mode == n ]] || tag="[$mode] "
    row "$section" "$tag$lhs" "$desc" ""
  done <"$f/keymap.lua"

  # blink.cmp: ["<Tab>"] = { "select_next", "fallback" },
  local re_c="^\[[\"${q}]([^\"${q}]+)[\"${q}]\][[:space:]]*=[[:space:]]*\{(.*)\}"
  while IFS= read -r line || [[ -n $line ]]; do
    line=${line##+([[:space:]])}
    [[ $line =~ $re_c ]] || continue
    desc=${BASH_REMATCH[2]//[\"\']/}
    desc=${desc##+([[:space:]])}
    desc=${desc%%+([[:space:]])}
    row "Completion (blink.cmp)" "[i] ${BASH_REMATCH[1]}" "$desc" ""
  done <"$NVIM_DIR/lua/plugins/cmp.lua"
}

#!/bin/bash

# List of applications to check if they are running
declare -A APPS
APPS=(
    ["syncthing"]="󱞒 Syncthing"
    ["mongod"]=" MongoDB"
)

out=""
tooltip=""
for i in ${!APPS[@]}; do
    if pgrep -x $i > /dev/null; then 
        icon=$(echo ${APPS[$i]} | cut -d' ' -f1)
        tool=$(echo ${APPS[$i]} | cut -d' ' -f2-)
        if [[ "$out" == "" ]]; then
            out="$out""$icon"
        else
            out="$out ""$icon"
        fi
        tooltip="$tooltip""$tool "
    fi
done

echo $(jq -cn \
        --arg one "$out" \
        --arg two "$tooltip" \
        '{text: $one, tooltip: $two}')

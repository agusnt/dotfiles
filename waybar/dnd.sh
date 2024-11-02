#!/bin/bash

if [[ "$1" == "init" ]]; then
    if [[ "$(makoctl mode)" == "default" ]]; then
        echo ""
    elif [[ "$(makoctl mode)" == "dnd" ]]; then
        echo "󰂛"
    else
        echo ""
    fi
    exit
fi

if [[ "$(makoctl mode)" == "default" ]]; then
    makoctl mode -a dnd >/dev/null 2>&1
    makoctl mode -r default >/dev/null 2>&1
else
    makoctl mode -a default >/dev/null 2>&1
    makoctl mode -r dnd >/dev/null 2>&1
fi

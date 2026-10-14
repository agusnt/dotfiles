#!/usr/bin/python3
"""Colour the focused border according to the layout of its container.

Sway cannot pick border colours per layout, so this listens to focus, move
and key-binding events and re-issues `client.focused` with a colour that
depends on the layout of the focused window's parent:

  tabbed  -> TABBED_COLOR
  stacked -> STACKED_COLOR
  other   -> the normal focused colour (same as 10-looks.conf)

The default colour comes from colors.conf and is restored on exit.
"""

import os
import re
import signal
import subprocess
import sys
import time

import i3ipc

COLORS_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                           '..', 'colors.conf')
DEFAULT = 'c_yellow'
# Gruvbox Material (medium, dark) accents; not in colors.conf, which holds
# the original Gruvbox palette
TABBED_COLOR = '#7daea3'
STACKED_COLOR = '#e78a4e'
INDICATOR = 'c_aqua_b'
TEXT = 'c_bg'


def load_palette():
    """Return {name: '#rrggbb'} parsed from the `set $name #hex` lines."""
    palette = {}
    with open(COLORS_FILE) as f:
        for line in f:
            m = re.match(r'set \$(\w+) (#[0-9a-fA-F]{6})', line)
            if m:
                palette[m.group(1)] = m.group(2)
    return palette


def kill_previous():
    """Stop older instances (this script runs from exec_always on reload)."""
    me = os.getpid()
    out = subprocess.run(['pgrep', '-f', os.path.abspath(__file__)],
                         capture_output=True, text=True).stdout
    for pid in out.split():
        if int(pid) != me:
            try:
                os.kill(int(pid), signal.SIGTERM)
            except ProcessLookupError:
                pass


def apply(ipc, palette, state):
    """Set client.focused for the layout of the focused window's parent."""
    focused = ipc.get_tree().find_focused()
    layout = focused.parent.layout if focused and focused.parent else ''
    name = {'tabbed': TABBED_COLOR, 'stacked': STACKED_COLOR}.get(layout, DEFAULT)
    if name == state.get('name'):
        return
    state['name'] = name
    c = palette.get(name, name)
    ipc.command('client.focused %s %s %s %s %s' % (
        c, c, palette[TEXT], palette[INDICATOR], c))


def main():
    kill_previous()
    palette = load_palette()
    ipc = i3ipc.Connection()
    state = {}

    def on_exit(*_):
        try:
            state['name'] = None
            state_default = palette[DEFAULT]
            ipc.command('client.focused %s %s %s %s %s' % (
                state_default, state_default, palette[TEXT],
                palette[INDICATOR], state_default))
        finally:
            sys.exit(0)

    signal.signal(signal.SIGTERM, on_exit)
    signal.signal(signal.SIGINT, on_exit)

    def refresh(conn, _event):
        apply(conn, palette, state)

    apply(ipc, palette, state)
    # Layout changes come from key bindings (no window event is guaranteed)
    ipc.on(i3ipc.Event.WINDOW, refresh)
    # The binding event fires before sway runs the command: let it finish
    ipc.on(i3ipc.Event.BINDING, lambda conn, e: (time.sleep(0.05), refresh(conn, e)))
    ipc.on(i3ipc.Event.WORKSPACE_FOCUS, refresh)
    ipc.main()  # returns when sway exits


if __name__ == '__main__':
    main()

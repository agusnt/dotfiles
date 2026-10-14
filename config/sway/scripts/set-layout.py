#!/usr/bin/python3
"""Switch the focused window to the tabbed or stacking layout.

Usage: set-layout.py tabbed|stacking

If the window already lives in a tabbed/stacked container, that container is
switched in place (no nesting). Otherwise only the focused window is wrapped
in its own container, so the windows beside it keep their layout.
"""

import sys

import i3ipc

LAYOUTS = ('tabbed', 'stacking')


def main():
    if len(sys.argv) != 2 or sys.argv[1] not in LAYOUTS:
        sys.exit('usage: %s tabbed|stacking' % sys.argv[0])
    layout = sys.argv[1]
    ipc = i3ipc.Connection()
    focused = ipc.get_tree().find_focused()
    parent_layout = focused.parent.layout if focused and focused.parent else ''
    if parent_layout in ('tabbed', 'stacked'):
        ipc.command('layout %s' % layout)
    else:
        ipc.command('splitv; layout %s' % layout)


if __name__ == '__main__':
    main()

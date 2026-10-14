#!/usr/bin/python3
"""Dim unfocused tiling windows.

The focused window and every floating window stay opaque; all other windows
get DIM_OPACITY. The whole tree is recomputed on each window event, so there
is no state that can get out of sync. Opacity is restored on exit.
"""

import signal
import sys

import i3ipc

DIM_OPACITY = 0.90


def is_floating(con):
    """Return True for floating windows (automatic or user-made)."""
    return con.floating in ('auto_on', 'user_on')


def apply_opacity(ipc):
    """Set the opacity of every window according to the current focus."""
    tree = ipc.get_tree()
    focused = tree.find_focused()
    for con in tree.leaves():
        keep = is_floating(con) or (focused is not None and con.id == focused.id)
        con.command('opacity %s' % (1 if keep else DIM_OPACITY))


def restore_opacity(ipc):
    """Make every window fully opaque again."""
    for con in ipc.get_tree().leaves():
        con.command('opacity 1')


def main():
    ipc = i3ipc.Connection()

    def on_exit(*_):
        try:
            restore_opacity(ipc)
        finally:
            sys.exit(0)

    signal.signal(signal.SIGTERM, on_exit)
    signal.signal(signal.SIGINT, on_exit)

    apply_opacity(ipc)
    # Focus, new, close, move and floating changes are all window events
    ipc.on(i3ipc.Event.WINDOW, lambda conn, _event: apply_opacity(conn))
    ipc.main()  # returns when sway exits


if __name__ == '__main__':
    main()

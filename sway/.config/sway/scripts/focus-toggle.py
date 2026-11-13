#!/usr/bin/python3
"""Toggle the focus between a window and its parent container.

On a window it selects the parent (focus parent); on a container it goes back
down to the child that was focused before (focus child).
"""

import i3ipc


def main():
    ipc = i3ipc.Connection()
    focused = ipc.get_tree().find_focused()
    if focused and focused.nodes:
        ipc.command('focus child')
    else:
        ipc.command('focus parent')


if __name__ == '__main__':
    main()

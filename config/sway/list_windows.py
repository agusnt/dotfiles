#!/usr/bin/python3
from i3ipc import Connection, Event

i3 = Connection()

# Query for actual workspaces
info = []
workspaces = i3.get_workspaces()
for workspace in workspaces:
    if "-1" in workspace.ipc_data["name"]:
        continue
    info.append(
        "{:8s} | {}: {}".format(
            workspace.ipc_data["output"],
            workspace.ipc_data["name"],
            workspace.ipc_data["representation"],
        )
    )

# print information
for i in info:
    print(i)

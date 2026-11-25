#!/usr/bin/env bash
# taskwarrior-tui key bindings (sourced by cheatsheet.sh; needs sway.sh for `row`).
# The keys are the taskwarrior-tui defaults plus the shortcuts and reports set in
# taskwarrior/.taskrc, listed here by hand.

rows_tasks() {
  local s

  s="Open"
  row "$s" "Super+Shift+t" "Toggle taskwarrior-tui (floating window)" ""
  row "$s" "taskwarrior-tui -r NAME" "Start on another report" "today, week, inbox"

  s="Navigate"
  row "$s" "j / k" "Next / previous task" ""
  row "$s" "g / G" "First / last task" ""
  row "$s" "Ctrl-d / Ctrl-u" "Page down / up" ""
  row "$s" "] / [" "Next / previous tab" "Tasks, Projects, Timesheet, Calendar"
  row "$s" "z" "Zoom the task details" ""
  row "$s" "Enter" "Show the task details" ""
  row "$s" "q" "Quit" ""

  s="Edit tasks"
  row "$s" "a" "Add a task" "Buy milk +home due:tomorrow"
  row "$s" "l" "Log a task as done" ""
  row "$s" "e" "Edit in \$EDITOR" ""
  row "$s" "m" "Modify" "due:friday pri:H project:x"
  row "$s" "A" "Annotate" ""
  row "$s" "x" "Mark done" ""
  row "$s" "d" "Delete" "asks first"
  row "$s" "s" "Start / stop" ""
  row "$s" "u" "Undo" "asks first"
  row "$s" "y" "Duplicate" ""

  s="Select and filter"
  row "$s" "v" "Select the task" ""
  row "$s" "V" "Select all" ""
  row "$s" "/" "Filter" "+work project:x due:today"
  row "$s" "Esc" "Clear the filter" ""
  row "$s" "c" "Context menu" "work, home"
  row "$s" "r" "Report menu" "next, today, week, inbox"
  row "$s" "R" "Refresh" ""
  row "$s" "!" "Run a task command" ""

  s="Shortcuts (taskwarrior/.taskrc)"
  row "$s" "1" "Start / stop (and the Timewarrior clock)" ""
  row "$s" "2" "Toggle the +next tag" ""
  row "$s" "3" "Annotate from a pop-up prompt" ""
  row "$s" "4" "Today's Timewarrior summary" "notification"

  s="Reports (taskwarrior/.taskrc)"
  row "$s" "next" "Pending by urgency" "default"
  row "$s" "today" "Due or scheduled today, plus overdue" ""
  row "$s" "week" "Due before the end of the week" ""
  row "$s" "inbox" "No project and no tags yet" ""
}

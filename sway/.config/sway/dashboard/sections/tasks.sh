#!/usr/bin/env bash
# Taskwarrior section: counters, next tasks and per-project summary (sourced by dashboard.sh).

# Common options: no footer, forced colours, width taken from the terminal
TASK_OPTS=(rc.verbose=nothing rc._forcecolor=on rc.confirmation=off)

data_tasks_head() {
  local pend over today c=$GRN
  pend=$(task +PENDING count 2>/dev/null)
  over=$(task +OVERDUE count 2>/dev/null)
  today=$(task +DUETODAY count 2>/dev/null)
  ((over > 0)) && c=$RED
  printf 'Pending %s   Due today %s   Overdue %s%s%s\n' "$pend" "$today" "$c" "$over" "$R"
}

data_tasks_next() {
  task "${TASK_OPTS[@]}" rc.defaultwidth="$task_w" limit:10 next 2>&1
}

data_tasks_summary() {
  task "${TASK_OPTS[@]}" rc.defaultwidth="$task_w" summary 2>&1
}

sec_tasks() {
  local next summary
  # Width for the task tables: half the screen when shown side by side
  task_w=$cols
  ((cols >= 112)) && task_w=$((cols / 2))
  title "Tasks"
  if ! command -v task >/dev/null; then
    printf '%staskwarrior is not installed (apt install taskwarrior)%s\n' "$DIMC" "$R"
    return
  fi
  cached tasks_head 20 data_tasks_head
  echo
  next=$(cached tasks_next 20 data_tasks_next)
  summary=$(cached tasks_summary 20 data_tasks_summary)
  if ((cols >= 112)); then
    sbs "$next" "$summary" $((cols / 2))
  else
    printf '%s\n\n%s\n' "$next" "$summary"
  fi
}

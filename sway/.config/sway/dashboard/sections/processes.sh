#!/usr/bin/env bash
# Top processes section (sourced by dashboard.sh).

# Instantaneous CPU: second frame of top (the first one is an average since start)
data_procs_cpu() {
  top -b -n2 -d1 -o %CPU -w 200 | awk '/^ *PID/ {n++; c=0; next} n==2 && c<5 && NF {printf "%6s%% %6s%%  %s\n", $9, $10, $12; c++}'
}

data_procs_mem() {
  ps -eo pmem,rss,comm --sort=-pmem | awk 'NR>1 && NR<=4 {printf "%6s%% %6dM  %s\n", $1, $2/1024, $3}'
}

sec_processes() {
  title "Processes"
  printf '%s   CPU     MEM  by CPU%s\n' "$DIMC" "$R"
  cached procs_cpu 4 data_procs_cpu
  printf '%s   MEM     RSS  by memory%s\n' "$DIMC" "$R"
  cached procs_mem 10 data_procs_mem
}

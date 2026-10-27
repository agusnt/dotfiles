#!/usr/bin/env bash
# Investments section: daily, monthly and yearly evolution from Yahoo Finance
# (sourced by dashboard.sh). Holdings come from INVEST_FILE (not in git).

data_invest() {
  local sym units name j
  while read -r sym units name; do
    [[ -z $sym || $sym == \#* ]] && continue
    # units are optional: a second field that is not a number is the name
    if [[ $units != +([0-9.]) ]]; then name="$units $name"; units=0; fi
    name=${name%% }
    j=$(curl -fsS --max-time 10 -A 'Mozilla/5.0' \
      "https://query1.finance.yahoo.com/v8/finance/chart/${sym}?range=1y&interval=1d") || continue
    # symbol, units, name, price now, price 1 day / 1 month / 1 year ago, 1-year sparkline
    jq -r --arg s "$sym" --arg u "${units:-0}" --arg n "$name" '
      .chart.result[0] as $r
      | ([$r.timestamp, $r.indicators.quote[0].close] | transpose | map(select(.[1] != null))) as $p
      | select(($p | length) > 1)
      | ($p | last) as $l
      | ($p | map(select(.[0] <= $l[0] - 30 * 86400)) | last // $p[0])[1] as $m
      | ($p | map(.[1])) as $c
      | ($c | min) as $lo | ($c | max) as $hi
      | ([range(0; 40)] | map($c[(. * ($c | length - 1) / 39) | floor])
         | map(if $hi == $lo then 3 else ((. - $lo) / ($hi - $lo) * 7 | round) end)
         | map("▁▂▃▄▅▆▇█"[.:. + 1]) | join("")) as $spark
      | [$s, $u, $n, ($r.meta.regularMarketPrice // $l[1]), $p[-2][1], $m, $p[0][1], $spark] | @tsv' <<<"$j"
  done <"$INVEST_FILE" | awk -F'\t' -v G="$GRN" -v E="$RED" -v D="$DIMC" -v R="$R" '
    function pct(now, ref,   v, c, s) {
      if (ref == 0) return sprintf("%8s", "n/a")
      v = (now / ref - 1) * 100
      c = v < 0 ? E : G
      s = sprintf("%+.1f%%", v)
      return sprintf("%s%8s%s", c, s, R)
    }
    {
      lbl = substr($3 != "" ? $3 : $1, 1, 8)
      printf "%-8s %9.2f %s %s %s", lbl, $4, pct($4, $5), pct($4, $6), pct($4, $7)
      printf "\n"
      n++; name[n] = lbl; spark[n] = $8; col[n] = $4 < $7 ? E : G
    }
    END {
      if (n) printf "\n%s1 year%s\n", D, R
      for (i = 1; i <= n; i++) printf "%-8s %s%s%s\n", name[i], col[i], spark[i], R
    }' | { printf '%s%-8s %9s %8s %8s %8s%s\n' "$DIMC" "" "price" "day" "month" "year" "$R"; cat; }
}

sec_invest() {
  title "Investments"
  if [[ ! -r $INVEST_FILE ]]; then
    printf '%screate %s%s\n' "$DIMC" "$INVEST_FILE" "$R"
    return
  fi
  cached invest 600 data_invest
}

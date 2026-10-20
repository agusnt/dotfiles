#!/usr/bin/env bash
# Weather section: icon + current conditions + 3-day forecast from wttr.in
# (sourced by dashboard.sh).

# weather_kind CODE: map a wttr.in/WorldWeatherOnline condition code to an icon name
weather_kind() {
  case $1 in
  113) echo sun ;;
  116) echo partly ;;
  119 | 122) echo cloud ;;
  143 | 248 | 260) echo fog ;;
  200 | 386 | 389 | 392 | 395) echo thunder ;;
  179 | 182 | 227 | 230 | 323 | 326 | 329 | 332 | 335 | 338 | 350 | 362 | 365 | 368 | 371 | 374 | 377) echo snow ;;
  176 | 185 | 263 | 266 | 281 | 284 | 293 | 296 | 299 | 302 | 305 | 308 | 311 | 314 | 317 | 320 | 353 | 356 | 359) echo rain ;;
  *) echo cloud ;;
  esac
}

# weather_art KIND: 5-line, 13-column coloured icon
weather_art() {
  local sun=$'\e[1;33m' cloud=$'\e[37m' rain=$'\e[34m' snow=$'\e[1;37m' bolt=$'\e[1;33m' fog=$'\e[2;37m'
  local -a c=() l=()
  case $1 in
  sun)
    c=("$sun" "$sun" "$sun" "$sun" "$sun")
    l=('    \   /    ' '     .-.     ' '  - (   ) -  ' '     ’-’     ' '    /   \    ')
    ;;
  partly)
    c=("$sun" "$sun" "$cloud" "$cloud" "$cloud")
    l=('   \  /      ' ' _ /"".-.    ' '   \_(   ).  ' '   /(___(__) ' '             ')
    ;;
  rain)
    c=("$cloud" "$cloud" "$cloud" "$rain" "$rain")
    l=('     .--.    ' '  .-(    ).  ' ' (___.__)__) ' '  ‘ ‘ ‘ ‘    ' '   ‘ ‘ ‘ ‘   ')
    ;;
  snow)
    c=("$cloud" "$cloud" "$cloud" "$snow" "$snow")
    l=('     .--.    ' '  .-(    ).  ' ' (___.__)__) ' '   *  *  *   ' '  *  *  *    ')
    ;;
  thunder)
    c=("$cloud" "$cloud" "$cloud" "$bolt" "$bolt")
    l=('     .--.    ' '  .-(    ).  ' ' (___.__)__) ' '    /_ /_    ' '     / /     ')
    ;;
  fog)
    c=("$fog" "$fog" "$fog" "$fog" "$fog")
    l=('             ' ' _ - _ - _ - ' '  _ - _ - _  ' ' _ - _ - _ - ' '             ')
    ;;
  *)
    c=("$cloud" "$cloud" "$cloud" "$cloud" "$cloud")
    l=('             ' '     .--.    ' '  .-(    ).  ' ' (___.__)__) ' '             ')
    ;;
  esac
  local i
  for i in 0 1 2 3 4; do printf '%s%s%s\n' "${c[i]}" "${l[i]}" "$R"; done
}

data_weather() {
  local j code temp feels desc wind hum rain art text
  j=$(curl -fsS --max-time 10 "https://wttr.in/${CITY// /+}?format=j1&lang=en") || return
  IFS=$'\t' read -r code temp feels desc wind hum rain < <(jq -r '
    .current_condition[0] |
    [.weatherCode, .temp_C, .FeelsLikeC, .weatherDesc[0].value, .windspeedKmph, .humidity, .precipMM] | @tsv' <<<"$j")

  art=$(weather_art "$(weather_kind "$code")")
  # Leading blank line: centre the text next to the 5-line icon
  text=$'\n'"${B}${temp}°C${R}  ${desc}"$'\n'"feels ${feels}°   wind ${wind} km/h"$'\n'"humidity ${hum}%   rain ${rain} mm"
  sbs "$art" "$text" 15
  echo
  jq -r '.weather[] | "\(.date | split("-") | "\(.[2])/\(.[1])")  \(.mintempC)°/\(.maxtempC)°  rain \([.hourly[].chanceofrain | tonumber] | max)%  \(.hourly[4].weatherDesc[0].value)"' <<<"$j"
}

sec_weather() {
  printf '%sWeather · %s%s  %s(c: change city)%s\n' "$CYN" "$CITY" "$R" "$DIMC" "$R"
  cached weather 600 data_weather
}

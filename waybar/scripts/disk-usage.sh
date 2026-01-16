#!/usr/bin/env bash
set -euo pipefail

used_total="$(
  df -B1 / |
    awk 'NR==2 {
      printf "%5.1f GiB/ %5.1f GiB",
      $3/1024/1024/1024, $4/1024/1024/1024
    }'
)"

home="$(
  paste \
    <(
      du -xh --max-depth=1 "$HOME" 2>/dev/null |
        sed "s|\t$HOME|\t~|" |
        sort -hr |
        column -t -s $'\t' -o ' '
    ) \
    <(
      du -xh --max-depth=1 "$HOME/.cache" 2>/dev/null |
        sed "s|\t$HOME|\t~|" |
        sort -hr |
        column -t -s $'\t' -o ' '
    ) |
  column -t -s $'\t' -o ' │ ' |
awk -v C="#dcdcdc" '
  BEGIN { FS = " │ " }
  {
    plain = $0
    if (length(plain) > max) max = length(plain)
    if (sep == 0) {
      sep = index(plain, " │ ")
      if (sep > 0) sep += 1
    }

    left  = $1
    right = $2

    if (match(left, /^[^[:space:]]+[[:space:]]+/)) {
      pre  = substr(left, 1, RLENGTH)
      path = substr(left, RLENGTH+1)
      left = pre "<span foreground=\"" C "\">" path "</span>"
    }
    if (match(right, /^[^[:space:]]+[[:space:]]+/)) {
      pre  = substr(right, 1, RLENGTH)
      path = substr(right, RLENGTH+1)
      right = pre "<span foreground=\"" C "\">" path "</span>"
    }

    lines[NR] = left " │ " right
  }
  END {
    for (i=1; i<=NR; i++) {
      print lines[i]
      if (i==1) {
        for (j=1; j<=max; j++) {
          printf (j==sep ? "┼" : "─")
        }
        print ""
      }
    }
  }
'
)"

tooltip="$(
  python3 -c 'import json,sys; s=sys.stdin.read(); print(json.dumps(s)[1:-1])' <<<"$home"
)"

printf '{"text":"%s","tooltip":"%s"}\n' "$used_total" "$tooltip"


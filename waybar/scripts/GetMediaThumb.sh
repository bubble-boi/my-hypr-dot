#!/bin/bash
set -euo pipefail

cover_path="/tmp/cover.jpeg"
last_key_path="/tmp/last_album_art_key.txt"
dummy_path="$HOME/.config/waybar/img/.musicicon"

pick_player() {
  local p
  while read -r p; do
    [[ -z "$p" ]] && continue
    if [[ "$(playerctl -p "$p" status 2>/dev/null || true)" == "Playing" ]]; then
      echo "$p"
      return 0
    fi
  done < <(playerctl -l 2>/dev/null || true)

  playerctl -l 2>/dev/null | head -n 1 || true
}

player="$(pick_player)"
if [[ -z "${player:-}" ]]; then
  rm -f "$cover_path" "$last_key_path"
  echo "$dummy_path"
  exit 0
fi

if ! playerctl -p "$player" status >/dev/null 2>&1; then
  rm -f "$cover_path" "$last_key_path"
  echo "$dummy_path"
  exit 0
fi

album_art="$(playerctl -p "$player" metadata mpris:artUrl 2>/dev/null || true)"

if [[ -z "${album_art:-}" ]]; then
  rm -f "$cover_path" "$last_key_path"
  echo "$dummy_path"
  exit 0
fi

key="${player}|${album_art}"
if [[ -f "$last_key_path" ]] && grep -qFx "$key" "$last_key_path"; then
  echo "$cover_path"
  exit 0
fi

if [[ "$album_art" == data:image/*\;base64,* ]]; then
  printf '%s' "${album_art#*,}" | base64 -d > "$cover_path" || {
    rm -f "$cover_path" "$last_key_path"
    echo "$dummy_path"
    exit 0
  }
else
  curl -fsSL "$album_art" -o "$cover_path" || {
    rm -f "$cover_path" "$last_key_path"
    echo "$dummy_path"
    exit 0
  }
fi

echo "$key" > "$last_key_path"
echo "$cover_path"


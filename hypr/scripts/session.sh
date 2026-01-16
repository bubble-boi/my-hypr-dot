#!/usr/bin/env bash
set -euo pipefail

# PKILL
pkill -x mako 2>/dev/null || true
pkill -x fcitx5 2>/dev/null || true
pkill -x hyprpaper 2>/dev/null || true
pkill -x wl-paste 2>/dev/null || true
pkill -x wl-clip-persist 2>/dev/null || true
pkill -x waybar 2>/dev/null || true

# EXEC
mako &
fcitx5 -d &
hyprpaper &
wl-paste --type text  --watch cliphist store &
wl-paste --type image --watch cliphist store &
wl-clip-persist --clipboard regular &

# WAYBAR
wait_layer() {
  for _ in {1..100}; do
    hyprctl layers 2>/dev/null | grep -Eq "pid:[[:space:]]*$!([[:space:]]|$)" && return 0
    sleep 0.02
  done
  return 1
}

waybar \
  -c ~/.config/waybar/configs/config-top-edge.jsonc \
  -s ~/.config/waybar/styles/style-edge.css &

wait_layer

waybar \
  -c ~/.config/waybar/configs/config-bottom-edge.jsonc \
  -s ~/.config/waybar/styles/style-edge.css &

wait_layer

waybar \
  -c ~/.config/waybar/configs/config-top.jsonc \
  -s ~/.config/waybar/styles/style-top.css &

wait_layer

waybar \
  -c ~/.config/waybar/configs/config-bottom.jsonc \
  -s ~/.config/waybar/styles/style-bottom.css &

wait_layer

waybar \
  -c ~/.config/waybar/configs/config-right-edge.jsonc \
  -s ~/.config/waybar/styles/style-edge.css &

wait_layer

waybar \
  -c ~/.config/waybar/configs/config-left-edge.jsonc \
  -s ~/.config/waybar/styles/style-edge.css &

wait_layer

waybar \
  -c ~/.config/waybar/configs/config-right.jsonc \
  -s ~/.config/waybar/styles/style-right.css &

wait_layer

waybar \
  -c ~/.config/waybar/configs/config-left.jsonc \
  -s ~/.config/waybar/styles/style-left.css &

exit 0


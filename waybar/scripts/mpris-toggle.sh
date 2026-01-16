#!/usr/bin/env bash

echo "󰐊"

playerctl --follow status 2>/dev/null | while read -r s; do
  case "$s" in
    Playing) echo "󰏤" ;;
    Paused)  echo "󰐊" ;;
    *)       echo "󰐊" ;;
  esac
done


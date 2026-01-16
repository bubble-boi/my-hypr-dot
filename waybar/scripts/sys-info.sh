#!/usr/bin/env bash

export TEXT="$(uname -s -n -m)"

export TOOLTIP="$(
  files=(
    /sys/devices/virtual/dmi/id/bios_date
    /sys/devices/virtual/dmi/id/bios_release
    /sys/devices/virtual/dmi/id/bios_vendor
    /sys/devices/virtual/dmi/id/bios_version
    /sys/devices/virtual/dmi/id/sys_vendor
    /sys/devices/virtual/dmi/id/product_name
    /sys/devices/virtual/dmi/id/product_version
    /sys/devices/system/cpu/present
    /sys/class/drm/card0/device/vendor
    /sys/class/power_supply/BAT0/model_name
    /sys/block/nvme0n1/device/model
    /proc/sys/kernel/osrelease
  )


  for f in "${files[@]}"; do
    [ -r "$f" ] || continue
    val="$(cat "$f")"
    printf '%s\n ↪ <span foreground="#dcdcdc">%s</span>\n\n' "$f" "$val"
  done
)"

python3 - <<'PY'
import json, os
print(json.dumps({
  "text": os.environ["TEXT"],
  "tooltip": os.environ["TOOLTIP"]
}, ensure_ascii=False))
PY


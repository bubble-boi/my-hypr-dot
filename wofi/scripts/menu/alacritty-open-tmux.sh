#!/usr/bin/env bash
# ARGS: required

set -e

pane="${1:-4}"
tmp="$(mktemp --suffix=.toml)"

cat >"$tmp" <<'EOF'
[general]
import = [ "~/.config/alacritty/alacritty.toml" ]

[terminal.shell]
program = "/usr/bin/tmux"
EOF

case "$pane" in
  2)
    cat >>"$tmp" <<'EOF'
args = [
  "new","-A","-s","main",
  ";","split-window","-h"
]
EOF
    ;;
  4)
    cat >>"$tmp" <<'EOF'
args = [
  "new","-A","-s","main",
  ";","split-window","-h",
  ";","split-window","-v",
  ";","select-pane","-t","0",
  ";","split-window","-v"
]
EOF
    ;;
  9)
    cat >>"$tmp" <<'EOF'
args = [
  "new","-A","-s","main",
  ";","split-window","-h",
  ";","split-window","-v",
  ";","split-window","-t","0",
  ";","split-window","-v",
  ";","split-window","-h",
  ";","split-window","-t","0",
  ";","split-window","-v",
  ";","split-window","-h",
  ";","select-layout","tiled"
]
EOF
    ;;
  *)
    echo "unsupported pane: $pane" >&2
    exit 1
    ;;
esac

alacritty --config-file "$tmp" &


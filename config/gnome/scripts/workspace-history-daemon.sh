#!/bin/bash

# Watches which workspace is active and remembers the one you were on right
# before it, so workspace-toggle.sh can jump back there. GNOME has no
# built-in signal for this, so this just polls `wmctrl -d` and writes the
# previous workspace number to a state file whenever the current one
# changes. Runs as the workspace-history systemd --user service, started by
# install/workspace-toggle.sh.

set -uo pipefail

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/gnome-workspace-history"
HISTORY_FILE="$STATE_DIR/previous"
mkdir -p "$STATE_DIR"

current_workspace() {
  wmctrl -d 2>/dev/null | awk '/\*/{print $1}'
}

last="$(current_workspace)"
while true; do
  sleep 0.25
  current="$(current_workspace)"
  if [[ -n $current && $current != "$last" ]]; then
    echo "$last" > "$HISTORY_FILE"
    last="$current"
  fi
done

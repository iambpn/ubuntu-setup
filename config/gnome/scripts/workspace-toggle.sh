#!/bin/bash

# Jump back to the workspace you were on before the current one. Bound to
# Super+` in config/gnome/hotkeys.sh. Relies on the state file that
# workspace-history-daemon.sh keeps up to date in the background.

set -uo pipefail

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/gnome-workspace-history"
HISTORY_FILE="$STATE_DIR/previous"

[[ -f $HISTORY_FILE ]] || exit 0

current="$(wmctrl -d 2>/dev/null | awk '/\*/{print $1}')"
previous="$(<"$HISTORY_FILE")"

if [[ -n $previous && $previous != "$current" ]]; then
  wmctrl -s "$previous"
fi

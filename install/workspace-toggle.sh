#!/bin/bash

# Super+` toggles back to the workspace you were on before the current one.
# GNOME has no built-in "previous workspace" shortcut, so a small daemon
# (config/gnome/scripts/workspace-history-daemon.sh) watches which
# workspace is active and remembers the one before it. The shortcut itself
# is wired up in config/gnome/hotkeys.sh, which this script runs at the end.

set -eEo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v wmctrl &>/dev/null; then
  echo "Installing wmctrl..."
  sudo apt-get update -y
  sudo apt-get install -y wmctrl
fi

# --- Background workspace-history daemon --------------------------------
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
mkdir -p "$SYSTEMD_USER_DIR"
sed "s|__DAEMON_PATH__|$REPO_DIR/config/gnome/scripts/workspace-history-daemon.sh|" \
  "$REPO_DIR/config/gnome/scripts/workspace-history.service" \
  > "$SYSTEMD_USER_DIR/workspace-history.service"

systemctl --user daemon-reload
systemctl --user enable --now workspace-history.service

# --- Shortcut ---------------------------------------------------------
bash "$REPO_DIR/config/gnome/hotkeys.sh"

echo 'Workspace toggle ready. Press Super+` to jump back to your previous workspace.'

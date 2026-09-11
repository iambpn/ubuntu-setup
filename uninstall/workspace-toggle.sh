#!/bin/bash

# Revert install/workspace-toggle.sh: stop the workspace-history daemon and
# remove wmctrl. The Super+` shortcut itself is dropped by uninstall/hotkeys.sh.

set -uo pipefail

systemctl --user disable --now workspace-history.service 2>/dev/null || true
rm -f "$HOME/.config/systemd/user/workspace-history.service"
systemctl --user daemon-reload 2>/dev/null || true

rm -rf "${XDG_RUNTIME_DIR:-/tmp}/gnome-workspace-history"

sudo apt-get remove -y wmctrl 2>/dev/null || true

echo "Workspace toggle removed."

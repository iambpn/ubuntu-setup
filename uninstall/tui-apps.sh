#!/bin/bash

# Revert install/tui-apps.sh: remove btop and lazygit, the app-grid
# launchers for btop / lazygit / lazydocker, and their downloaded icons.

set -uo pipefail

APPS="$HOME/.local/share/applications"

sudo apt-get remove -y btop 2>/dev/null || true
sudo rm -f /usr/local/bin/lazygit

rm -f "$APPS"/btop.desktop "$APPS"/lazygit.desktop "$APPS"/lazydocker.desktop
rm -f "$APPS"/icons/lazygit.png "$APPS"/icons/lazydocker.png
rm -rf "$HOME/.config/lazygit"

update-desktop-database "$APPS" 2>/dev/null || true

echo "btop, lazygit, and the TUI launchers removed."

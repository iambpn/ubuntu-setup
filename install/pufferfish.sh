#!/bin/bash

# Pufferfish clipboard-history manager, opened with Super+V. The shortcut
# is set in config/gnome/hotkeys.sh, which this script runs at the end.

set -eEo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# --- Install ------------------------------------------------------------
if ! command -v pufferfish &>/dev/null; then
  echo "Installing Pufferfish..."
  # The official installer builds and drops the binary in /usr/local/bin
  # and adds a login autostart entry. It needs `make` and `tar`.
  sudo apt-get update -y
  sudo apt-get install -y make
  curl -fsSL https://raw.githubusercontent.com/iambpn/pufferfish/main/install.sh | sudo sh
fi

# ydotool lets Pufferfish paste the picked entry for you. Without it,
# copy still works but you paste by hand.
if ! command -v ydotool &>/dev/null; then
  sudo apt-get install -y ydotool
fi
systemctl --user enable --now ydotoold 2>/dev/null || true

# --- Shortcut ---------------------------------------------------------
bash "$REPO_DIR/config/gnome/hotkeys.sh"

echo "Pufferfish ready. Press Super+V for clipboard history."

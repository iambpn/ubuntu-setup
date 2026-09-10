#!/bin/bash

# Flameshot screenshot tool. Its Super+Shift+S shortcut (and the removal of
# the Ctrl+Alt+L logout binding) live in config/gnome/hotkeys.sh, which this
# script runs at the end.

set -eEo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v flameshot &>/dev/null; then
  echo "Installing Flameshot..."
  sudo apt-get update -y
  sudo apt-get install -y flameshot
fi

bash "$REPO_DIR/config/gnome/hotkeys.sh"

echo "Flameshot ready. Press Super+Shift+S to capture."

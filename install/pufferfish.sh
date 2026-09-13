#!/bin/bash

# Pufferfish clipboard-history manager, opened with Super+V. The shortcut
# is set in config/gnome/hotkeys.sh, which this script runs at the end.

set -eEo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# --- Install ------------------------------------------------------------
if ! command -v pufferfish &>/dev/null; then
  echo "Installing Pufferfish..."
  # /bin/sh installer, runs as root, needs make + tar.
  sudo apt-get update -y
  sudo apt-get install -y make
  fetch_and_run --sudo --sh https://raw.githubusercontent.com/iambpn/pufferfish/main/install.sh
fi

# ydotool lets Pufferfish paste the picked entry for you. Without it,
# copy still works but you paste by hand.
if ! command -v ydotool &>/dev/null; then
  sudo apt-get install -y ydotool
fi
systemctl --user enable --now ydotoold 2>/dev/null || true

# ydotool's udev rule locks /dev/uinput to the "input" group, so ydotoold
# can't inject the paste keystroke unless the user is in that group.
if ! id -nG "$USER" | tr ' ' '\n' | grep -qx input; then
  sudo usermod -aG input "$USER"
  echo "Added $USER to the input group. Log out and back in for it to apply."
fi

# --- Shortcut ---------------------------------------------------------
bash "$REPO_DIR/config/gnome/hotkeys.sh"

echo "Pufferfish ready. Press Super+V for clipboard history."

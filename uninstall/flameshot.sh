#!/bin/bash

# Revert install/flameshot.sh: remove the package and its config.

set -uo pipefail

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

sudo apt-get remove -y flameshot 2>/dev/null || true
rm -rf "$CONFIG_HOME/flameshot"

echo "Flameshot removed."

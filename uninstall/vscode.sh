#!/bin/bash

# Revert install/vscode.sh: remove the package, apt repo, key, and config.

set -uo pipefail

sudo apt-get remove -y code 2>/dev/null || true
sudo rm -f /etc/apt/sources.list.d/vscode.list \
           /etc/apt/keyrings/packages.microsoft.gpg
rm -rf "$HOME/.config/Code" "$HOME/.vscode"

echo "VS Code removed."

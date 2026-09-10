#!/bin/bash

# Revert install/chrome.sh: remove the package, apt repo, key, and profile.

set -uo pipefail

sudo apt-get remove -y google-chrome-stable 2>/dev/null || true
sudo rm -f /etc/apt/sources.list.d/google-chrome.list \
           /etc/apt/sources.list.d/google-chrome-unstable.list \
           /etc/apt/keyrings/google-chrome.gpg
rm -rf "$HOME/.config/google-chrome"

echo "Google Chrome removed."

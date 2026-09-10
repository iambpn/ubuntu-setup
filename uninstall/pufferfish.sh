#!/bin/bash

# Revert install/pufferfish.sh: run the official uninstaller, then clear
# anything it left behind and the deps it pulled in.

set -uo pipefail

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

if command -v pufferfish &>/dev/null && command -v curl &>/dev/null; then
  curl -fsSL https://raw.githubusercontent.com/iambpn/pufferfish/main/install.sh | sudo sh -s -- uninstall || true
fi
sudo rm -f /usr/local/bin/pufferfish /etc/xdg/autostart/pufferfish.desktop
rm -f "$HOME/Desktop/pufferfish.desktop"
rm -rf "$CONFIG_HOME/pufferfish" "$HOME/.local/share/pufferfish"

systemctl --user disable --now ydotoold 2>/dev/null || true
sudo apt-get remove -y ydotool 2>/dev/null || true
sudo apt-get remove -y make 2>/dev/null || true # was pulled in only to build pufferfish

echo "Pufferfish removed."

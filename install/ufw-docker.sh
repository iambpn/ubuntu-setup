#!/bin/bash

# ufw-docker (github.com/chaifeng/ufw-docker): Docker bypasses UFW by
# writing its own iptables rules, so a container's published ports stay
# reachable even with `ufw deny`. This tool patches UFW to close that gap.
# Not packaged for Ubuntu, so pull the script straight from its repo.
#
# This only installs the tool. It doesn't enable ufw or run
# `ufw-docker install` (that edits live firewall rules), since this repo
# doesn't otherwise manage ufw. Do that yourself once ufw is enabled:
#   sudo ufw-docker install && sudo ufw reload

set -eEo pipefail

if ! command -v ufw &>/dev/null; then
  echo "Installing ufw..."
  sudo apt-get update -y
  sudo apt-get install -y ufw
fi

if ! command -v ufw-docker &>/dev/null; then
  echo "Installing ufw-docker..."
  sudo curl -fsSL -o /usr/local/bin/ufw-docker \
    https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker
  sudo chmod +x /usr/local/bin/ufw-docker
fi

echo "ufw-docker installed. Run 'sudo ufw-docker install' after enabling ufw."

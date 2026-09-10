#!/bin/bash

# Revert install/docker.sh: remove the engine, apt repo, key, group
# membership, and — since we are going back to a fresh state — the images
# and volumes under /var/lib/docker.

set -uo pipefail

sudo systemctl disable --now docker docker.socket containerd 2>/dev/null || true
sudo apt-get remove -y docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras 2>/dev/null || true
sudo rm -f /etc/apt/sources.list.d/docker.list /etc/apt/keyrings/docker.gpg
sudo gpasswd -d "$USER" docker 2>/dev/null || true
sudo groupdel docker 2>/dev/null || true
sudo rm -rf /var/lib/docker /var/lib/containerd /etc/docker
rm -rf "$HOME/.docker"

echo "Docker removed (including /var/lib/docker images and volumes)."

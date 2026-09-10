#!/bin/bash

# Docker Engine + Buildx + Compose plugin from Docker's official apt repo,
# and add the current user to the docker group.

set -eEo pipefail

if ! command -v docker &>/dev/null; then
  echo "Installing Docker Engine..."
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt-get update -y
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

sudo systemctl enable --now docker

# Run docker without sudo. Needs a fresh login to take effect.
if ! id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then
  sudo usermod -aG docker "$USER"
  echo "Added $USER to the docker group. Log out and back in for it to apply."
fi

echo "Docker installed."

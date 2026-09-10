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

# docker.socket fails to start without the `docker` group, and a reinstall
# doesn't always recreate it.
getent group docker >/dev/null || sudo groupadd docker

sudo systemctl enable docker
if ! sudo systemctl start docker; then
  echo "Note: docker did not start right now. It is enabled and will start" \
       "on the next boot, or run 'sudo systemctl start docker' again."
fi

if ! id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then
  sudo usermod -aG docker "$USER"
  echo "Added $USER to the docker group. Log out and back in for it to apply."
fi

echo "Docker installed."

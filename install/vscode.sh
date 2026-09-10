#!/bin/bash

# Visual Studio Code from Microsoft's apt repo.

set -eEo pipefail

if ! command -v code &>/dev/null; then
  echo "Installing VS Code..."
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
    | sudo gpg --dearmor -o /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
    | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
  sudo apt-get update -y
  sudo apt-get install -y code
fi

echo "VS Code installed."

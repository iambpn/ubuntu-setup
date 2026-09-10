#!/bin/bash

# Google Chrome (stable) from Google's apt repo.

set -eEo pipefail

if ! command -v google-chrome &>/dev/null; then
  echo "Installing Google Chrome..."
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
    | sudo gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" \
    | sudo tee /etc/apt/sources.list.d/google-chrome.list >/dev/null
  sudo apt-get update -y
  sudo apt-get install -y google-chrome-stable
fi

echo "Google Chrome installed."

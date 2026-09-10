#!/bin/bash

# lazydocker: a terminal UI for Docker. Not in apt, so pull the latest
# release binary from GitHub.

set -eEo pipefail

if ! command -v lazydocker &>/dev/null; then
  echo "Installing lazydocker..."
  url="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazydocker/releases/latest \
    | grep -oP '"browser_download_url":\s*"\K[^"]*Linux_x86_64\.tar\.gz')"
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/lazydocker.tar.gz" "$url"
  tar -xzf "$tmp/lazydocker.tar.gz" -C "$tmp" lazydocker
  sudo install -m 755 "$tmp/lazydocker" /usr/local/bin/lazydocker
  rm -rf "$tmp"
fi

echo "lazydocker installed."

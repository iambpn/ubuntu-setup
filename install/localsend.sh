#!/bin/bash

# LocalSend: share files across devices on the local network. Installs the
# latest .deb release from GitHub (better desktop/network integration than
# the sandboxed Flatpak build).

set -eEo pipefail

if ! command -v localsend_app &>/dev/null; then
  echo "Installing LocalSend..."
  url="$(curl -fsSL https://api.github.com/repos/localsend/localsend/releases/latest \
    | grep -oP '"browser_download_url":\s*"\K[^"]*linux-x86-64\.deb')"
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/localsend.deb" "$url"
  sudo apt-get install -y "$tmp/localsend.deb"
  rm -rf "$tmp"
fi

echo "LocalSend installed."

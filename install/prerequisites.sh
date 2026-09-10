#!/bin/bash

# Base tools that the other install/ scripts assume are already there.
# A fresh Ubuntu (especially a minimal install) does not ship curl or gpg,
# and every script below uses one or both to add apt repos and download
# release tarballs. Install them once, up front.

set -eEo pipefail

# What each package gives us:
#   curl            - downloads used all over install/ and config/
#   ca-certificates - HTTPS trust roots, so curl and apt can verify servers
#   gnupg           - the `gpg` command, used to dearmor apt signing keys
#   git             - clone/update this repo and anything it pulls
#   tar, unzip, xz-utils - unpack the release archives (zellij, proto, ...)
#   fontconfig      - `fc-list` / `fc-cache`, used by install/terminal.sh
packages=(
  curl
  ca-certificates
  gnupg
  git
  tar
  unzip
  xz-utils
  fontconfig
)

missing=()
for p in "${packages[@]}"; do
  dpkg -s "$p" &>/dev/null || missing+=("$p")
done

if ((${#missing[@]})); then
  echo "Installing prerequisites: ${missing[*]}"
  sudo apt-get update -y
  sudo apt-get install -y "${missing[@]}"
else
  echo "Prerequisites already installed."
fi

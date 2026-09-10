#!/bin/bash

# proto, moonrepo's multi-language toolchain manager.
# https://moonrepo.dev/proto

set -eEo pipefail

if [[ ! -x "$HOME/.proto/bin/proto" ]] && ! command -v proto &>/dev/null; then
  echo "Installing proto..."
  # The installer needs these to unpack its archive.
  sudo apt-get update -y
  sudo apt-get install -y unzip xz-utils
  # Piped (non-interactive): installs to ~/.proto and adds it to your
  # shell profile.
  curl -fsSL https://moonrepo.dev/install/proto.sh | bash
fi

echo "proto installed. Open a new shell to pick it up."

#!/bin/bash

# proto, moonrepo's multi-language toolchain manager.
# https://moonrepo.dev/proto

set -eEo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

if [[ ! -x "$HOME/.proto/bin/proto" ]] && ! command -v proto &>/dev/null; then
  echo "Installing proto..."
  # The installer needs these to unpack its archive.
  sudo apt-get update -y
  sudo apt-get install -y unzip xz-utils
  # The installer ends with an interactive "which shell profile?" menu.
  fetch_and_run https://moonrepo.dev/install/proto.sh
fi

echo "proto installed. Open a new shell to pick it up."

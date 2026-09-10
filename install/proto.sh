#!/bin/bash

# proto, moonrepo's multi-language toolchain manager.
# https://moonrepo.dev/proto

set -eEo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

if [[ ! -x "$HOME/.proto/bin/proto" ]] && ! command -v proto &>/dev/null; then
  echo "Installing proto..."
  # The installer needs these to unpack its archive.
  sudo apt-get update -y
  sudo apt-get install -y unzip xz-utils
  # The installer ends with an interactive "which shell profile?" menu.
  fetch_and_run https://moonrepo.dev/install/proto.sh
fi

# --- Global .prototools ---------------------------------------------
# proto reads ~/.proto/.prototools as its global config and rewrites it as
# tools are installed, so copy our starting point in rather than symlink.
# Only seed it when it's missing, to keep this re-run safe.
src="$REPO_DIR/config/proto/.prototools"
dst="$HOME/.proto/.prototools"
mkdir -p "$(dirname "$dst")"
if [[ -e $dst ]]; then
  echo "Left existing $dst alone"
else
  cp "$src" "$dst"
  echo "Copied $src -> $dst"
fi

echo "proto installed. Open a new shell to pick it up."

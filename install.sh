#!/bin/bash

# Run every script under install/ to set up a fresh Ubuntu machine.
# Ordering matters in a couple of places (docker before lazydocker, the
# lazy-* tools before the launcher script), so the list is explicit.
#
# Safe to re-run: each install/ script skips work that is already done.

set -uo pipefail

INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/install" && pwd)"

scripts=(
  prerequisites.sh
  terminal.sh
  shell.sh
  vscode.sh
  chrome.sh
  docker.sh
  proto.sh
  lazydocker.sh
  tui-apps.sh
  gnome-extensions.sh
  flameshot.sh
  pufferfish.sh
  flatpak-apps.sh
  localsend.sh
)

echo "This installs everything in install/. It needs sudo and takes a while."
echo

failed=()
for s in "${scripts[@]}"; do
  echo "==================================================================="
  echo "### install/$s"
  echo "==================================================================="
  if ! bash "$INSTALL_DIR/$s"; then
    echo "!!! install/$s failed"
    failed+=("$s")
  fi
  echo
done

if ((${#failed[@]})); then
  echo "Done, but these failed: ${failed[*]}"
  echo "Re-run them one at a time to see why."
  exit 1
fi

cat <<'EOF'
All install scripts finished.

Log out and back in so these take effect:
  - docker group membership
  - the disabled / re-enabled GNOME extensions
  - proto's shell profile changes
EOF

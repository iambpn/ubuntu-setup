#!/bin/bash

# Run every script under install/ to set up a fresh Ubuntu machine.
# Ordering matters in a couple of places, so the list is explicit:
#   - docker before lazydocker, and the lazy-* tools before tui-apps.sh
#     (the launcher script)
#   - flatpak-apps.sh (installs Zen Browser) before flameshot.sh /
#     pufferfish.sh, since both run config/gnome/hotkeys.sh, which pins
#     Zen Browser to the GNOME dash
#
# Safe to re-run: each install/ script skips work that is already done.

set -uo pipefail

INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/install" && pwd)"

scripts=(
  prerequisites.sh
  terminal.sh
  shell.sh
  git.sh
  vscode.sh
  chrome.sh
  docker.sh
  ufw-docker.sh
  proto.sh
  lazydocker.sh
  tui-apps.sh
  gnome-extensions.sh
  clock.sh
  flatpak-apps.sh
  flameshot.sh
  pufferfish.sh
  workspace-toggle.sh
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

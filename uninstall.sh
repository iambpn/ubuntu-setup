#!/bin/bash

# Run every script under uninstall/ to revert what install/ and config/ set
# up, back toward a fresh Ubuntu state. Each uninstall/ script also works on
# its own if you only want to undo one piece.
#
# Best effort: a package that was already installed before setup is still
# removed here, and the PATH line `pipx ensurepath` added to your shell
# profile is left in place (harmless on its own).

set -uo pipefail

UNINSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/uninstall" && pwd)"

if [[ ${1:-} != "-y" && ${1:-} != "--yes" ]]; then
  read -rp "This removes the software and settings added by this repo. Continue? [y/N] " ans
  [[ ${ans,,} == y || ${ans,,} == yes ]] || { echo "Aborted."; exit 0; }
fi

for script in hotkeys gnome-extensions flameshot pufferfish \
              vscode chrome docker ufw-docker proto lazydocker tui-apps flatpak-apps localsend \
              git shell terminal; do
  echo
  echo "### uninstall/$script.sh"
  bash "$UNINSTALL_DIR/$script.sh"
done

echo
echo "==> Cleaning up unused dependencies"
sudo apt-get autoremove -y 2>/dev/null || true

cat <<'EOF'

Done. Notes:
  - Log out and back in (or restart GNOME Shell) so the removed and
    re-enabled extensions take effect in the running session.
  - Docker was fully removed, including images and volumes under
    /var/lib/docker.
  - `pipx` and `make` were removed as setup dependencies. Reinstall with
    `sudo apt install pipx make` if you use either for something else.
  - `flatpak` itself and the flathub remote were left in place.
  - proto's lines were stripped from the common shell profiles. The
    `~/.local/bin` PATH line `pipx ensurepath` added was left alone;
    delete it by hand if you want it gone.
EOF

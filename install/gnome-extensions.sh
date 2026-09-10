#!/bin/bash

# GNOME Shell extensions setup, in the same self-contained style as
# terminal.sh. Installs the tooling to manage extensions, then the two
# extensions I use: Hide Top Bar and TopHat. Their settings live in
# config/gnome/extensions.sh, which this script runs at the end.

set -eEo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# --- Extension manager + CLI --------------------------------------------------
# The GUI manager is handy for toggling and settings. gnome-extensions-cli
# (the `gext` command) is what lets this script install extensions without
# clicking through a browser. It comes from pipx.
sudo apt-get update -y
sudo apt-get install -y pipx gnome-shell-extension-manager

pipx install --system-site-packages gnome-extensions-cli || \
  pipx upgrade gnome-extensions-cli
pipx ensurepath

# pipx puts its binaries here; make sure this session can find `gext`.
export PATH="$HOME/.local/bin:$PATH"

# --- Extensions ------------------------------------------------------------
# UUIDs as published on extensions.gnome.org.
extensions=(
  "hidetopbar@mathieu.bidon.ca" # Hide Top Bar
  "tophat@fflewddur.github.io"  # TopHat
)

for uuid in "${extensions[@]}"; do
  echo "Installing $uuid..."
  gext install "$uuid"
  gext enable "$uuid"
done

# --- Make the extension settings reachable by gsettings ---------------------
# gsettings can only set keys whose schema it can find. Copy each extension's
# schema into the system directory and recompile, the same way omabuntu does.
EXT_DIR="$HOME/.local/share/gnome-shell/extensions"
for uuid in "${extensions[@]}"; do
  for schema in "$EXT_DIR/$uuid"/schemas/*.gschema.xml; do
    [ -f "$schema" ] && sudo cp "$schema" /usr/share/glib-2.0/schemas/
  done
done
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

# --- Apply the settings ---------------------------------------------------
bash "$REPO_DIR/config/gnome/extensions.sh"

echo "GNOME extensions installed and configured. Log out and back in to load them."

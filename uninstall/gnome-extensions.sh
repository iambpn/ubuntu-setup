#!/bin/bash

# Revert install/gnome-extensions.sh and config/gnome/extensions.sh:
# re-enable the stock extensions, undo the extension settings, then remove
# the installed extensions and their tooling.

set -uo pipefail # not -e: keep cleaning up past any one failure

# --- config/gnome/extensions.sh -------------------------------------
gnome-extensions enable ding@rastersoft.com 2>/dev/null || true
gnome-extensions enable ubuntu-dock@ubuntu.com 2>/dev/null || true
dconf reset -f /org/gnome/shell/extensions/tophat/ 2>/dev/null || true
dconf reset -f /org/gnome/shell/extensions/hidetopbar/ 2>/dev/null || true

# --- install/gnome-extensions.sh -----------------------------------
for ext in hidetopbar@mathieu.bidon.ca tophat@fflewddur.github.io; do
  gnome-extensions disable "$ext" 2>/dev/null || true
  rm -rf "$HOME/.local/share/gnome-shell/extensions/$ext"
done

command -v pipx &>/dev/null && pipx uninstall gnome-extensions-cli 2>/dev/null || true
sudo apt-get remove -y gnome-shell-extension-manager pipx 2>/dev/null || true

sudo rm -f /usr/share/glib-2.0/schemas/org.gnome.shell.extensions.tophat.gschema.xml \
           /usr/share/glib-2.0/schemas/org.gnome.shell.extensions.hidetopbar.gschema.xml
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null || true

echo "GNOME extensions and their settings reverted."

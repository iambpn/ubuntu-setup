#!/bin/bash

# Revert install/flatpak-apps.sh: undo the Zen / PortProton overrides and
# uninstall the three Flatpak apps. Leaves the flatpak package and the
# flathub remote in place (removing them tends to break other things).

set -uo pipefail

flatpak override --user --reset app.zen_browser.zen 2>/dev/null || true
flatpak override --user --reset ru.linux_gaming.PortProton 2>/dev/null || true

flatpak uninstall --user -y --noninteractive \
  app.zen_browser.zen \
  com.github.tchx84.Flatseal \
  ru.linux_gaming.PortProton 2>/dev/null || true

flatpak uninstall --user -y --unused --noninteractive 2>/dev/null || true

echo "Zen Browser, Flatseal, and PortProton removed."

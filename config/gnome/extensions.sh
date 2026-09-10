#!/bin/bash

# Settings for the GNOME Shell extensions installed by
# install/gnome-extensions.sh. Split out so the values are easy to tweak
# and re-apply without reinstalling anything. The installer runs this at
# the end; you can also run it on its own after changing a value.

set -eEo pipefail

# --- Turn off Ubuntu defaults I don't use ----------------------------
# Desktop icons and the dock. `|| true` so a missing one isn't fatal.
for ext in ding@rastersoft.com ubuntu-dock@ubuntu.com; do
  gnome-extensions disable "$ext" 2>/dev/null || true
done

# --- Drop the Snap Store and Web search providers -------------------
# Same as unticking them in Settings > Search. Listing an id that isn't
# installed is harmless, so no need to check first.
disabled="$(gsettings get org.gnome.desktop.search-providers disabled)"
for id in snap-store_snap-store.desktop io.snapcraft.Store.desktop org.gnome.Epiphany.desktop; do
  if [[ $disabled != *"'$id'"* ]]; then
    if [[ $disabled == "@as []" || $disabled == "[]" ]]; then
      disabled="['$id']"
    else
      disabled="${disabled%]}, '$id']"
    fi
  fi
done
gsettings set org.gnome.desktop.search-providers disabled "$disabled"

# gsettings can only set keys in a schema it can see. install/gnome-extensions.sh
# copies each extension's schema into the system dir before calling this. If you
# run this script on its own before that, skip the block instead of aborting
# under `set -e`.
has_schema() { gsettings list-schemas | grep -qx "$1"; }

# --- TopHat -------------------------------------------------------------
if has_schema org.gnome.shell.extensions.tophat; then
  # CPU as a percentage, memory as used GB, and the network meter on.
  gsettings set org.gnome.shell.extensions.tophat show-cpu true
  gsettings set org.gnome.shell.extensions.tophat cpu-display 'numeric'
  gsettings set org.gnome.shell.extensions.tophat show-mem true
  gsettings set org.gnome.shell.extensions.tophat mem-display 'numeric'
  gsettings set org.gnome.shell.extensions.tophat mem-abs-units true
  gsettings set org.gnome.shell.extensions.tophat show-net true
  gsettings set org.gnome.shell.extensions.tophat network-usage-unit 'bytes'
else
  echo "TopHat schema not installed yet; skipping its settings."
fi

# --- Hide Top Bar -----------------------------------------------------
if has_schema org.gnome.shell.extensions.hidetopbar; then
  # Intellihide: only hide the panel when a window (the active one) needs the space.
  gsettings set org.gnome.shell.extensions.hidetopbar enable-intellihide true
  gsettings set org.gnome.shell.extensions.hidetopbar enable-active-window true

  # Sensitivity: reveal the panel on a mouse push to the top edge, keep the hot
  # corner alive while hidden, keep round corners, but don't open the overview.
  gsettings set org.gnome.shell.extensions.hidetopbar mouse-sensitive true
  gsettings set org.gnome.shell.extensions.hidetopbar mouse-sensitive-fullscreen-window true
  gsettings set org.gnome.shell.extensions.hidetopbar show-in-overview true
  gsettings set org.gnome.shell.extensions.hidetopbar hot-corner true
  gsettings set org.gnome.shell.extensions.hidetopbar mouse-triggers-overview false
  gsettings set org.gnome.shell.extensions.hidetopbar keep-round-corners true
  gsettings set org.gnome.shell.extensions.hidetopbar pressure-threshold 100
  gsettings set org.gnome.shell.extensions.hidetopbar pressure-timeout 1000
else
  echo "Hide Top Bar schema not installed yet; skipping its settings."
fi

echo "GNOME extension settings applied."

#!/bin/bash

# Turn the Hide Top Bar extension on or off. Bound to Shift+Super+H in
# config/gnome/hotkeys.sh. Toggling the extension itself (instead of its own
# shortcut-keybind setting) gives a plain on/off: enabled means the bar can
# hide, disabled means it always shows.

set -uo pipefail

EXT="hidetopbar@mathieu.bidon.ca"

if gnome-extensions list --enabled | grep -qx "$EXT"; then
  gnome-extensions disable "$EXT"
else
  gnome-extensions enable "$EXT"
fi

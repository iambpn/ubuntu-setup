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

# Match against these as strings, not with `... | grep -q`: grep exits on the
# first hit, the writer gets SIGPIPE, and `pipefail` then fails the pipe.
schemas="$(gsettings list-schemas 2>/dev/null)" || schemas=""

has_schema() {
  [[ $'\n'"$schemas"$'\n' == *$'\n'"$1"$'\n'* ]]
}

# set_key <schema> <key> <value>: set it only if the schema still defines
# that key, and don't let a rejected value stop the script. Extensions rename
# and drop keys between versions.
set_key() {
  local schema="$1" key="$2" value="$3" keys
  keys="$(gsettings list-keys "$schema" 2>/dev/null)" || keys=""
  if [[ $'\n'"$keys"$'\n' != *$'\n'"$key"$'\n'* ]]; then
    echo "  skip $schema $key: not in this version of the extension"
    return 0
  fi
  gsettings set "$schema" "$key" "$value" 2>/dev/null \
    || echo "  warn $schema $key: gsettings rejected '$value'"
}

# --- TopHat -------------------------------------------------------------
tophat=org.gnome.shell.extensions.tophat
if has_schema "$tophat"; then
  # CPU as a percentage, memory as used GB, and the network meter on.
  set_key "$tophat" show-cpu true
  set_key "$tophat" cpu-display 'numeric'
  set_key "$tophat" show-mem true
  set_key "$tophat" mem-display 'numeric'
  set_key "$tophat" mem-abs-units true
  set_key "$tophat" show-net true
  set_key "$tophat" network-usage-unit 'bytes'
else
  echo "TopHat schema not installed yet; skipping its settings."
fi

# --- Hide Top Bar -----------------------------------------------------
hidetopbar=org.gnome.shell.extensions.hidetopbar
if has_schema "$hidetopbar"; then
  # Intellihide: only hide the panel when a window (the active one) needs the space.
  set_key "$hidetopbar" enable-intellihide true
  set_key "$hidetopbar" enable-active-window true

  # Sensitivity: reveal the panel on a mouse push to the top edge, keep the hot
  # corner alive while hidden, keep round corners, but don't open the overview.
  set_key "$hidetopbar" mouse-sensitive true
  set_key "$hidetopbar" mouse-sensitive-fullscreen-window false
  set_key "$hidetopbar" show-in-overview true
  set_key "$hidetopbar" hot-corner true
  set_key "$hidetopbar" mouse-triggers-overview false
  set_key "$hidetopbar" keep-round-corners true
  set_key "$hidetopbar" pressure-threshold 100
  set_key "$hidetopbar" pressure-timeout 1000
else
  echo "Hide Top Bar schema not installed yet; skipping its settings."
fi

echo "GNOME extension settings applied."

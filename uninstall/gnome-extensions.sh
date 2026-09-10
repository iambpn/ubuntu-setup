#!/bin/bash

# Revert install/gnome-extensions.sh and config/gnome/extensions.sh:
# re-enable the stock extensions, undo the search-provider and extension
# settings, then remove the installed extensions and their tooling.

set -uo pipefail # not -e: keep cleaning up past any one failure

# Drop specific values from a gsettings array, leaving anything else in it.
array_remove() {
  # array_remove <schema[:path]> <key> <value>...
  local schema="$1" key="$2"; shift 2
  command -v python3 &>/dev/null || return 0
  python3 - "$schema" "$key" "$@" <<'PY'
import ast, subprocess, sys
schema, key, *drop = sys.argv[1:]
try:
    cur = subprocess.check_output(["gsettings", "get", schema, key], text=True).strip()
    lst = ast.literal_eval(cur)
except Exception:
    lst = []
lst = [x for x in lst if x not in drop]
subprocess.run(["gsettings", "set", schema, key, "@as []" if not lst else repr(lst)])
PY
}

# --- config/gnome/extensions.sh -------------------------------------
gnome-extensions enable ding@rastersoft.com 2>/dev/null || true
gnome-extensions enable ubuntu-dock@ubuntu.com 2>/dev/null || true
array_remove org.gnome.desktop.search-providers disabled \
  snap-store_snap-store.desktop io.snapcraft.Store.desktop org.gnome.Epiphany.desktop
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

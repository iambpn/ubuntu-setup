#!/bin/bash

# Revert config/gnome/hotkeys.sh: reset the keybindings it changed and drop
# the pufferfish / flameshot / workspace-toggle custom shortcuts, leaving
# any other custom shortcuts you have in place.

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

WM="org.gnome.desktop.wm.keybindings"
for k in cycle-windows cycle-windows-backward maximize switch-applications \
         switch-applications-backward toggle-fullscreen \
         switch-group switch-group-backward switch-input-source \
         switch-to-workspace-{1,2,3,4,5,6}; do
  gsettings reset "$WM" "$k" 2>/dev/null || true
done

for i in 1 2 3 4 5 6 7 8 9; do
  gsettings reset org.gnome.shell.keybindings "switch-to-application-$i" 2>/dev/null || true
done

# Restore the Super+V message-tray binding that hotkeys.sh cleared.
gsettings reset org.gnome.shell.keybindings toggle-message-tray 2>/dev/null || true

# Restore the default dash pinned apps.
gsettings reset org.gnome.shell favorite-apps 2>/dev/null || true

gsettings reset org.gnome.desktop.interface enable-hot-corners 2>/dev/null || true
gsettings reset org.gnome.mutter dynamic-workspaces 2>/dev/null || true
gsettings reset org.gnome.desktop.wm.preferences num-workspaces 2>/dev/null || true
gsettings reset org.gnome.mutter workspaces-only-on-primary 2>/dev/null || true

MK="org.gnome.settings-daemon.plugins.media-keys"
CB="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
gsettings reset "$MK" logout 2>/dev/null || true
for slot in pufferfish flameshot workspace-toggle; do
  array_remove "$MK" custom-keybindings "$CB/$slot/"
  dconf reset -f "$CB/$slot/" 2>/dev/null || true
done
if [[ "$(gsettings get "$MK" custom-keybindings 2>/dev/null)" == "@as []" ]]; then
  gsettings reset "$MK" custom-keybindings 2>/dev/null || true
fi

echo "GNOME shortcuts reverted."

#!/bin/bash

# Revert install/localsend.sh: remove the .deb package and app data.

set -uo pipefail

pkg="$(dpkg-query -W -f='${Package}\n' 2>/dev/null | grep -i '^localsend' | head -1)"
[[ -n $pkg ]] && sudo apt-get remove -y "$pkg" 2>/dev/null || true
rm -rf "$HOME/.local/share/org.localsend.localsend_app" "$HOME/.config/localsend"

echo "LocalSend removed."

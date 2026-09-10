#!/bin/bash

# Revert install/shell.sh: drop the ~/.bashrc source line, unlink the
# configs (restoring any .bak), and remove starship.

set -uo pipefail

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

unlink_config() {
  # unlink_config <path under ~/.config>
  local dst="$CONFIG_HOME/$1"
  [[ -L $dst ]] && { rm -f "$dst"; echo "unlinked $dst"; }
  [[ -e "$dst.bak" ]] && { mv "$dst.bak" "$dst"; echo "restored $dst from .bak"; }
}

# Remove the line install/shell.sh appended (matched by its tag).
if [[ -f "$HOME/.bashrc" ]]; then
  sed -i '/# ubuntu-setup$/d' "$HOME/.bashrc"
fi

unlink_config starship.toml
unlink_config shell/rc.bash
rmdir --ignore-fail-on-non-empty "$CONFIG_HOME/shell" "$CONFIG_HOME/starship" 2>/dev/null || true

sudo apt-get remove -y starship 2>/dev/null || true
sudo rm -f /usr/local/bin/starship

echo "Shell prompt setup reverted."

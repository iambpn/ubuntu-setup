#!/bin/bash

# Revert install/terminal.sh: unlink the configs (restoring any .bak the
# installer made), then remove Alacritty, Zellij, wl-clipboard, and the
# Nerd Fonts.

set -uo pipefail

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

unlink_config() {
  # unlink_config <path under ~/.config>
  local dst="$CONFIG_HOME/$1"
  [[ -L $dst ]] && { rm -f "$dst"; echo "unlinked $dst"; }
  [[ -e "$dst.bak" ]] && { mv "$dst.bak" "$dst"; echo "restored $dst from .bak"; }
}

unlink_config alacritty/alacritty.toml
unlink_config zellij/config.kdl
rmdir --ignore-fail-on-non-empty "$CONFIG_HOME/alacritty" "$CONFIG_HOME/zellij" 2>/dev/null || true

sudo apt-get remove -y alacritty 2>/dev/null || true
sudo rm -f /usr/local/bin/zellij
sudo apt-get remove -y wl-clipboard 2>/dev/null || true

sudo apt-get remove -y fonts-cascadia-mono-nf 2>/dev/null || true
rm -rf "$HOME/.local/share/fonts/CaskaydiaMono"
rm -rf "$HOME/.local/share/fonts/JetBrainsMono"
fc-cache -f >/dev/null 2>&1 || true

echo "Terminal setup reverted."

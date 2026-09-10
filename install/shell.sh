#!/bin/bash

# Starship prompt, ported from omabuntu (config/starship.toml + its bash
# init). Gives a minimal prompt: path + git only, no user@host. Starship
# replaces PS1 and does not set a terminal title, so config/shell/rc.bash
# emits the CWD as the title itself to keep Zellij pane names useful.

set -eEo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"  # link_config

# --- Install starship ---------------------------------------------------
# The apt package isn't in every Ubuntu release, so always use the official
# installer. -y skips its confirmation prompt; it escalates with sudo itself
# to write into /usr/local/bin.
if ! command -v starship &>/dev/null; then
  echo "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# --- Configs ----------------------------------------------------------
link_config "starship/starship.toml" "starship.toml"
link_config "shell/rc.bash" "shell/rc.bash"

# --- Wire into ~/.bashrc --------------------------------------------
# One sourcing line, tagged so uninstall/shell.sh can find it again.
RC_LINE='[ -f "$HOME/.config/shell/rc.bash" ] && . "$HOME/.config/shell/rc.bash"  # ubuntu-setup'
if ! grep -qxF "$RC_LINE" "$HOME/.bashrc" 2>/dev/null; then
  printf '\n%s\n' "$RC_LINE" >>"$HOME/.bashrc"
  echo "Added the ubuntu-setup source line to ~/.bashrc"
fi

echo "Shell prompt ready. Open a new shell to see it."

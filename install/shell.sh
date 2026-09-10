#!/bin/bash

# Starship prompt, ported from omabuntu (config/starship.toml + its bash
# init). Gives a minimal prompt: path + git only, no user@host. Starship
# also sets the terminal title to the path, so Zellij pane titles / tabs
# read "~" instead of "user@host: ~/path".

set -eEo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"  # link_config, fetch_and_run

# --- Install starship ---------------------------------------------------
# In apt from Ubuntu 23.10 on; fall back to the official installer if this
# release doesn't carry it.
if ! command -v starship &>/dev/null; then
  echo "Installing starship..."
  if apt-cache policy starship 2>/dev/null | grep -qE 'Candidate: [^(]'; then
    sudo apt-get update -y
    sudo apt-get install -y starship
  else
    echo "No apt package for this Ubuntu; using the official installer..."
    fetch_and_run --sudo --sh https://starship.rs/install/install.sh --yes
  fi
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

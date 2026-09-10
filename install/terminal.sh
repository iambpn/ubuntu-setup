#!/bin/bash

# Terminal setup copied from omabuntu: Alacritty + Zellij, Tokyo Night look,
# CaskaydiaMono Nerd Font. Framework references from omabuntu are stripped,
# so this stands alone.

set -eEo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"  # link_config

# --- Alacritty ---------------------------------------------------------------
if ! command -v alacritty &>/dev/null; then
  echo "Installing Alacritty..."
  sudo apt-get update -y
  sudo apt-get install -y alacritty
fi

# --- Nerd Font -------------------------------------------------------------
# The `fonts-cascadia-mono-nf` apt package only exists on Ubuntu 25.10+;
# older releases fall back to the nerd-fonts release zip.
if ! fc-list | grep -qi "CaskaydiaMono Nerd Font"; then
  echo "Installing CaskaydiaMono Nerd Font..."
  if apt-cache policy fonts-cascadia-mono-nf 2>/dev/null | grep -qE 'Candidate: [^(]'; then
    sudo apt-get install -y fonts-cascadia-mono-nf
  else
    echo "No apt package for this Ubuntu; downloading the font release instead..."
    tmp="$(mktemp -d)"
    curl -fsSL -o "$tmp/CascadiaMono.zip" \
      https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip
    mkdir -p "$HOME/.local/share/fonts"
    unzip -o "$tmp/CascadiaMono.zip" -d "$HOME/.local/share/fonts/CaskaydiaMono" >/dev/null
    rm -rf "$tmp"
  fi
  fc-cache -f >/dev/null
fi

# --- Zellij ---------------------------------------------------------------
# Not packaged for Ubuntu, so pull the latest static binary from GitHub.
if ! command -v zellij &>/dev/null; then
  echo "Installing Zellij..."
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/zellij.tar.gz" \
    "https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz"
  tar -xzf "$tmp/zellij.tar.gz" -C "$tmp"
  sudo install -m 755 "$tmp/zellij" /usr/local/bin/zellij
  rm -rf "$tmp"
fi

# --- wl-clipboard -------------------------------------------------------------
# Zellij's config.kdl uses `wl-copy` as its copy_command so copy-on-select
# reaches the Wayland system clipboard. Ubuntu doesn't ship it by default.
if ! command -v wl-copy &>/dev/null; then
  echo "Installing wl-clipboard..."
  sudo apt-get install -y wl-clipboard
fi

# --- Configs --------------------------------------------------------------
link_config "alacritty/alacritty.toml" "alacritty/alacritty.toml"
link_config "zellij/config.kdl" "zellij/config.kdl"

echo "Terminal setup done. Restart Alacritty to pick up the new config."

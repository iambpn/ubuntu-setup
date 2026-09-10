#!/bin/bash

# Flatpak apps from Flathub: Zen Browser, Flatseal, PortProton. Also applies
# the PortProton permission and env tweaks that would otherwise be set by
# hand in Flatseal.

set -eEo pipefail

# --- Flatpak + Flathub ---------------------------------------------
if ! command -v flatpak &>/dev/null; then
  echo "Installing Flatpak..."
  sudo apt-get update -y
  sudo apt-get install -y flatpak
fi
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# --- Apps ------------------------------------------------------
flatpak install --user -y --noninteractive flathub \
  app.zen_browser.zen \
  com.github.tchx84.Flatseal \
  ru.linux_gaming.PortProton

# --- Zen Browser: broaden filesystem access ---------------------
# Same as ticking "All system files" and "All user files" in Flatseal.
flatpak override --user app.zen_browser.zen \
  --filesystem=host \
  --filesystem=home

# --- PortProton: NVIDIA PRIME render offload, only on an NVIDIA GPU
if command -v nvidia-smi &>/dev/null || lspci 2>/dev/null | grep -qi nvidia || [[ -d /proc/driver/nvidia ]]; then
  flatpak override --user ru.linux_gaming.PortProton \
    --env=__GLX_VENDOR_LIBRARY_NAME=nvidia \
    --env=__NV_PRIME_RENDER_OFFLOAD=1
  echo "NVIDIA GPU detected: added PRIME offload env vars to PortProton."
fi

echo "Flatpak apps installed."

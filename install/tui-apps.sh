#!/bin/bash

# btop and lazygit, plus app-grid launchers that open each one in a
# terminal window. Same idea as omakub-tui-install in omabuntu: a normal
# .desktop entry with Terminal=false that runs the tool inside a terminal.

set -eEo pipefail

APPS="$HOME/.local/share/applications"
ICONS="$APPS/icons"
mkdir -p "$ICONS"

# --- btop (apt) --------------------------------------------------------
sudo apt-get update -y
sudo apt-get install -y btop

# Theme: Tokyo Night. btop ships this theme, so we only set the key in its
# config (creating the file if btop hasn't run yet). btop rewrites this file
# on exit, so linking it from the repo isn't a good fit.
BTOP_CONF="$HOME/.config/btop/btop.conf"
mkdir -p "$(dirname "$BTOP_CONF")"
touch "$BTOP_CONF"
if grep -q '^color_theme' "$BTOP_CONF"; then
  sed -i 's/^color_theme.*/color_theme = "tokyo-night"/' "$BTOP_CONF"
else
  echo 'color_theme = "tokyo-night"' >>"$BTOP_CONF"
fi

# --- lazygit (GitHub release binary; not in apt) --------------------
if ! command -v lazygit &>/dev/null; then
  echo "Installing lazygit..."
  url="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
    | grep -oP '"browser_download_url":\s*"\K[^"]*linux_x86_64\.tar\.gz')"
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/lazygit.tar.gz" "$url"
  tar -xzf "$tmp/lazygit.tar.gz" -C "$tmp" lazygit
  sudo install -m 755 "$tmp/lazygit" /usr/local/bin/lazygit
  rm -rf "$tmp"
fi

# --- Launchers ------------------------------------------------------
# Prefer Alacritty (installed by install/terminal.sh); otherwise use the
# freedesktop terminal helper.
if command -v alacritty &>/dev/null; then
  run_in_term() { echo "alacritty -e $1"; }
else
  run_in_term() { echo "xdg-terminal-exec $1"; }
fi

make_launcher() {
  # make_launcher <name> <command> <icon> <categories>
  cat >"$APPS/$1.desktop" <<EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=$1
Comment=$1
Exec=$(run_in_term "$2")
Icon=$3
Terminal=false
Categories=$4
StartupNotify=true
EOF
  chmod +x "$APPS/$1.desktop"
}

# btop ships its own themed icon with the apt package, so Icon=btop resolves.
make_launcher btop btop btop "System;Monitor;Utility;"

# lazygit has no packaged icon; grab the site favicon (a small PNG) and
# fall back to a generic terminal icon if that download fails.
if curl -fsSL -o "$ICONS/lazygit.png" https://www.lazygit.dev/favicon.ico; then
  make_launcher lazygit lazygit "$ICONS/lazygit.png" "Development;RevisionControl;Utility;"
else
  make_launcher lazygit lazygit utilities-terminal "Development;RevisionControl;Utility;"
fi

# lazydocker: install/lazydocker.sh installs the binary. If it's here, add a
# launcher too, with the Docker whale icon (same as omabuntu's "Docker").
if command -v lazydocker &>/dev/null; then
  curl -fsSL -o "$ICONS/lazydocker.png" \
    https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/docker.png || true
  if [[ -s "$ICONS/lazydocker.png" ]]; then
    make_launcher lazydocker lazydocker "$ICONS/lazydocker.png" "Development;System;Utility;"
  else
    make_launcher lazydocker lazydocker utilities-terminal "Development;System;Utility;"
  fi
fi

update-desktop-database "$APPS" 2>/dev/null || true

echo "btop, lazygit (and lazydocker if installed) added to the app grid."

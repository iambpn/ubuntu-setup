#!/bin/bash

# Global git config, plus delta for its diff pager.
#   config/git/config -> ~/.gitconfig
# delta: https://github.com/dandavison/delta

set -eEo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# --- delta -----------------------------------------------------------
# config/git/config sets `core.pager = delta`, so git diff/log/show break
# without it. Prefer apt (git-delta); fall back to the GitHub release .deb
# for releases where apt does not carry it.
if ! command -v delta &>/dev/null; then
  echo "Installing delta..."
  sudo apt-get update -y
  if ! sudo apt-get install -y git-delta; then
    url="$(curl -fsSL https://api.github.com/repos/dandavison/delta/releases/latest \
      | grep -oP '"browser_download_url":\s*"\K[^"]*' \
      | grep '_amd64\.deb$' | grep -v musl | head -n1)"
    tmp="$(mktemp -d)"
    curl -fsSL -o "$tmp/git-delta.deb" "$url"
    sudo apt-get install -y "$tmp/git-delta.deb"
    rm -rf "$tmp"
  fi
fi

# --- config --------------------------------------------------------
# Link to ~/.gitconfig, not ~/.config/git/config: git ignores the latter
# when ~/.gitconfig exists. Back up any real file already there.
src="$REPO_DIR/config/git/config"
dst="$HOME/.gitconfig"
if [[ -e $dst && ! -L $dst ]]; then
  echo "Backing up existing $dst -> $dst.bak"
  mv "$dst" "$dst.bak"
fi
ln -snf "$src" "$dst"
echo "Linked $dst -> $src"

echo "Git config linked. Set your identity with:"
echo "  git config-setup-name && git config-setup-email"

#!/bin/bash

# GNOME privacy settings, in the same self-contained style as the other
# install/ scripts. Just a gsettings tweak, no packages to install; the
# actual values live in config/gnome/privacy.sh, which this script runs.

set -eEo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "$REPO_DIR/config/gnome/privacy.sh"

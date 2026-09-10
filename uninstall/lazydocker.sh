#!/bin/bash

# Revert install/lazydocker.sh: remove the binary and its config.

set -uo pipefail

sudo rm -f /usr/local/bin/lazydocker
rm -rf "$HOME/.config/lazydocker"

echo "lazydocker removed."

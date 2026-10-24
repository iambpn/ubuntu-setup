#!/bin/bash

# Revert config/gnome/privacy.sh: turn File History back on.

set -uo pipefail # not -e: keep cleaning up past any one failure

PRIVACY="org.gnome.desktop.privacy"

gsettings reset "$PRIVACY" remember-recent-files 2>/dev/null || true

echo "File history setting reverted."

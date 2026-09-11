#!/bin/bash

# Revert config/gnome/clock.sh: reset the top bar clock back to its
# default format.

set -uo pipefail # not -e: keep cleaning up past any one failure

INTERFACE="org.gnome.desktop.interface"

for key in clock-format clock-show-weekday clock-show-date clock-show-seconds; do
  gsettings reset "$INTERFACE" "$key" 2>/dev/null || true
done

echo "Top bar clock format reverted."

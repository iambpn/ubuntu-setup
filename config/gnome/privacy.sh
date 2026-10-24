#!/bin/bash

# GNOME privacy settings. Split out like config/gnome/clock.sh so the
# value is easy to tweak and re-apply. install/privacy.sh runs this; you
# can also run it on its own.
#
# Turns off File History, so GNOME stops recording recently used files.

set -eEo pipefail

PRIVACY="org.gnome.desktop.privacy"

gsettings set $PRIVACY remember-recent-files false

echo "File history disabled."

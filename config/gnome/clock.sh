#!/bin/bash

# Top bar clock format. Split out like config/gnome/extensions.sh so the
# value is easy to tweak and re-apply. install/clock.sh runs this; you can
# also run it on its own.
#
# Turns the default "11:04 PM" into "Fri Sep 11 11:04 PM".

set -eEo pipefail

INTERFACE="org.gnome.desktop.interface"

gsettings set $INTERFACE clock-format '12h'
gsettings set $INTERFACE clock-show-weekday true
gsettings set $INTERFACE clock-show-date true
gsettings set $INTERFACE clock-show-seconds false

echo "Top bar clock format applied."

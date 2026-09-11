#!/bin/bash

# Revert install/ufw-docker.sh: remove the ufw-docker script. Leaves ufw
# itself in place, since it ships on Ubuntu by default.

set -uo pipefail

sudo rm -f /usr/local/bin/ufw-docker

echo "ufw-docker removed."

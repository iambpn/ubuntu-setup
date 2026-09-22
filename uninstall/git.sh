#!/bin/bash

# Revert install/git.sh: unlink ~/.gitconfig (restoring any .bak) and
# remove delta.

set -uo pipefail

dst="$HOME/.gitconfig"
[[ -L $dst ]] && { rm -f "$dst"; echo "unlinked $dst"; }
[[ -e "$dst.bak" ]] && { mv "$dst.bak" "$dst"; echo "restored $dst from .bak"; }

hooks_dst="$HOME/.config/git/hooks"
[[ -L $hooks_dst ]] && { rm -f "$hooks_dst"; echo "unlinked $hooks_dst"; }
[[ -e "$hooks_dst.bak" ]] && { mv "$hooks_dst.bak" "$hooks_dst"; echo "restored $hooks_dst from .bak"; }

sudo apt-get remove -y git-delta 2>/dev/null || true
sudo rm -f /usr/local/bin/delta /usr/bin/delta

echo "Git config setup reverted."

#!/bin/bash

# Revert install/proto.sh: remove ~/.proto and the lines the installer
# added to your shell profiles.

set -uo pipefail

rm -rf "$HOME/.proto"

# `proto setup` appends this block to the shell profile:
#   # proto
#   export PROTO_HOME="$HOME/.proto"
#   export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH"
# Drop every line of it: the `# proto` marker, anything mentioning
# PROTO_HOME, and any leftover reference to the ~/.proto path.
for f in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile" \
         "$HOME/.bash_profile" "$HOME/.config/fish/config.fish"; do
  [[ -f $f ]] && sed -i -e '/^# proto[[:space:]]*$/d' \
                        -e '/PROTO_HOME/d' \
                        -e '/\.proto/d' "$f"
done

echo "proto removed."

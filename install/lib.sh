#!/bin/bash

# Shared helpers for the install/ scripts. Source it near the top:
#   source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
#
# This file only defines functions; it does not change shell options.

# Fetch a remote install script and run it from a real file.
#
# Why not `curl URL | bash`: piping makes the downloaded script's stdin the
# pipe, so anything it tries to read from you (a "which shell profile?"
# menu, a yes/no prompt) gets EOF and either hangs or silently picks
# nothing. Running from a file leaves stdin on the terminal, so prompts
# work and the install won't get stuck halfway through install.sh.
#
# The temp file is always removed, and the real exit code is returned, so a
# caller with `set -e` still stops on a failed download or a failed script.
#
# Usage:
#   fetch_and_run [--sudo] [--sh] <url> [args passed to the script...]
#     --sudo  run the downloaded script as root
#     --sh    run it with sh instead of bash (match a #!/bin/sh installer)
fetch_and_run() {
  local runner=(bash) use_sudo=0

  while [[ "${1:-}" == --* ]]; do
    case "$1" in
      --sudo) use_sudo=1 ;;
      --sh) runner=(sh) ;;
      *) echo "fetch_and_run: unknown option $1" >&2; return 2 ;;
    esac
    shift
  done

  local url="$1"; shift
  local tmp rc=0
  tmp="$(mktemp)"

  if curl -fsSL "$url" -o "$tmp"; then
    if ((use_sudo)); then
      sudo "${runner[@]}" "$tmp" "$@" || rc=$?
    else
      "${runner[@]}" "$tmp" "$@" || rc=$?
    fi
  else
    rc=$?
  fi

  rm -f "$tmp"
  return "$rc"
}

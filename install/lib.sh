#!/bin/bash

# Shared helpers for the install/ scripts.
#   source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# Run a remote install script from a file, not `curl URL | bash`, so its
# interactive prompts still reach the terminal. Cleans up the temp file and
# returns the script's real exit code.
#
# Usage: fetch_and_run [--sudo] [--sh] <url> [script args...]
#   --sudo  run it as root
#   --sh    run it with sh, not bash (for a #!/bin/sh installer)
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

#!/bin/bash

# Shared helpers for the install/ scripts.
#   source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# Symlink a file from this repo's config/ into ~/.config, backing up any
# real file already there. Callers set REPO_DIR and CONFIG_HOME first.
#
# Usage: link_config <path under config/> <path under ~/.config>
link_config() {
  local src="$REPO_DIR/config/$1"
  local dst="$CONFIG_HOME/$2"

  mkdir -p "$(dirname "$dst")"
  if [[ -e $dst && ! -L $dst ]]; then
    echo "Backing up existing $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -snf "$src" "$dst"
  echo "Linked $dst -> $src"
}

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

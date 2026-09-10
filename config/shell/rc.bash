# Sourced from ~/.bashrc by install/shell.sh. Keep shell tweaks that should
# live with this repo here, not in ~/.bashrc directly.

# Starship prompt. It shows just the path (plus git), never user@host, and
# also sets the terminal/pane title to the path. That title is what Zellij
# would otherwise render as "user@host: ~/path" on a stock shell.
if [[ $- == *i* ]] && [[ ${TERM:-} != "dumb" ]] && command -v starship &>/dev/null; then
  eval "$(starship init bash)"
fi

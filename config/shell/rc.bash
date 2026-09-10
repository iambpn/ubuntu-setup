# Sourced from ~/.bashrc by install/shell.sh. Keep shell tweaks that should
# live with this repo here, not in ~/.bashrc directly.

# Starship prompt. It shows just the path (plus git), never user@host.
if [[ $- == *i* ]] && [[ ${TERM:-} != "dumb" ]] && command -v starship &>/dev/null; then
  eval "$(starship init bash)"

  # Starship replaces PS1 and sets no terminal title, so Zellij panes show
  # "Pane #1". Emit the CWD as the title ourselves via PROMPT_COMMAND,
  # which "starship init" keeps.
  __pane_title() { printf '\033]0;%s\007' "${PWD/#$HOME/\~}"; }
  PROMPT_COMMAND="__pane_title${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
fi

#!/bin/bash

# GNOME keyboard shortcuts. Split out like config/gnome/extensions.sh so the
# bindings are easy to tweak and re-apply. The install scripts that need a
# shortcut (pufferfish, flameshot) run this at the end; you can also run it
# on its own.

set -eEo pipefail

MEDIA_KEYS="org.gnome.settings-daemon.plugins.media-keys"
CUSTOM_BASE="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

# --- Custom command shortcuts --------------------------------------------
# GNOME stores these as a list of dconf paths, each with a name/command/
# binding triple. Append a slot to the list if it's missing, then fill it
# in. Named slots keep this re-runnable and leave other slots alone.
add_custom_shortcut() {
  # add_custom_shortcut <slot> <name> <command> <binding>
  local slot="$CUSTOM_BASE/$1/"
  local key="$MEDIA_KEYS.custom-keybinding:$slot"
  local list
  list="$(gsettings get $MEDIA_KEYS custom-keybindings)"
  if [[ $list != *"$slot"* ]]; then
    if [[ $list == "@as []" || $list == "[]" ]]; then
      list="['$slot']"
    else
      list="${list%]}, '$slot']"
    fi
    gsettings set $MEDIA_KEYS custom-keybindings "$list"
  fi
  gsettings set "$key" name "$2"
  gsettings set "$key" command "$3"
  gsettings set "$key" binding "$4"
}

# Free up Super+V: a fresh GNOME binds it to "toggle-message-tray". Keep
# Super+M for the tray and drop Super+V so it doesn't clash with the
# Pufferfish shortcut added next.
gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super>m']"

add_custom_shortcut pufferfish 'Pufferfish' 'pufferfish --history' '<Super>v'
add_custom_shortcut flameshot 'Flameshot' 'flameshot gui' '<Shift><Super>s'

# --- Window manager ---------------------------------------------------
WM="org.gnome.desktop.wm.keybindings"
gsettings set $WM cycle-windows "['<Super>Tab']"
gsettings set $WM cycle-windows-backward "['<Shift><Super>Tab']"
gsettings set $WM switch-windows "['<Alt>Tab']"
gsettings set $WM switch-windows-backward "['<Shift><Alt>Tab']"
gsettings set $WM maximize "['<Super>Up']"
gsettings set $WM switch-applications "['<Alt>Escape']"
gsettings set $WM switch-applications-backward "['<Shift><Alt>Escape']"
for i in 1 2 3 4 5 6; do
  gsettings set $WM "switch-to-workspace-$i" "['<Super>$i']"
done
gsettings set $WM toggle-fullscreen "['<Shift>F11']"

# Disabled on purpose: no separate key for cycling just the current app's
# windows, and don't let a key swap the keyboard layout.
gsettings set $WM switch-group "@as []"
gsettings set $WM switch-group-backward "@as []"
gsettings set $WM switch-input-source "@as []"

# --- Dash / dock pinned apps ----------------------------------------
# The exact set and order shown in the dash. btop.desktop and
# lazydocker.desktop are the launchers install/tui-apps.sh creates.
gsettings set org.gnome.shell favorite-apps "[
  'app.zen_browser.zen.desktop',
  'code.desktop',
  'Alacritty.desktop',
  'btop.desktop',
  'lazydocker.desktop',
  'org.gnome.Nautilus.desktop',
  'google-chrome.desktop',
  'org.gnome.Settings.desktop'
]"

# --- Workspaces and desktop behaviour --------------------------------
gsettings set org.gnome.desktop.interface enable-hot-corners true
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 6
gsettings set org.gnome.mutter workspaces-only-on-primary false

# --- GNOME Shell ----------------------------------------------------
SHELL_KB="org.gnome.shell.keybindings"
for i in 1 2 3 4 5 6 7 8 9; do
  gsettings set $SHELL_KB "switch-to-application-$i" "['<Alt>$i']"
done

# --- Drop Ctrl+Alt+L "log out" if a fresh install set it -------------
# Only clear it when that is the binding; leave any other value alone
# (the usual default is Ctrl+Alt+Delete).
logout_bind="$(gsettings get $MEDIA_KEYS logout)"
if [[ ${logout_bind,,} == *"<control><alt>l"* || ${logout_bind,,} == *"<primary><alt>l"* ]]; then
  gsettings set $MEDIA_KEYS logout "@as []"
  echo "Removed Ctrl+Alt+L logout shortcut."
fi

echo "GNOME shortcuts applied."

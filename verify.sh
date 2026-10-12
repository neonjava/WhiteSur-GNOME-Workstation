#!/usr/bin/env bash
set -euo pipefail

printf 'GNOME Shell: '; gnome-shell --version
printf 'User Themes: '; gnome-extensions info user-theme@gnome-shell-extensions.gcampax.github.com | sed -n 's/^  State: / /p'
printf 'Dash to Dock: '; gnome-extensions info dash-to-dock@micxgx.gmail.com | sed -n 's/^  State: / /p'
if test -f "$HOME/.local/share/gnome-shell/extensions/global-menu@unmade.space/metadata.json"; then
  printf 'Orbit Global Menu: '
  state="$(gnome-extensions info global-menu@unmade.space 2>/dev/null | sed -n 's/^  State: //p' || true)"
  printf '%s\n' "${state:-staged; log out and back in}"
fi
for item in \
  'org.gnome.shell.extensions.user-theme name' \
  'org.gnome.desktop.interface gtk-theme' \
  'org.gnome.desktop.interface icon-theme' \
  'org.gnome.desktop.interface cursor-theme' \
  'org.gnome.desktop.wm.preferences button-layout' \
  'org.gnome.shell.extensions.dash-to-dock dock-position' \
  'org.gnome.shell.extensions.dash-to-dock always-center-icons' \
  'org.gnome.shell.keybindings show-screenshot-ui' \
  'org.gnome.settings-daemon.plugins.media-keys search'; do
  read -r schema key <<< "$item"
  printf '%s %s: ' "$schema" "$key"
  gsettings get "$schema" "$key"
done
binding=org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/whitesur-spotlight/
if test -x "$HOME/.local/bin/whitesur-spotlight"; then
  printf 'WhiteSur app finder: '
  gsettings get "$binding" binding
fi

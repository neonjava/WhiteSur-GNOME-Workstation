#!/usr/bin/env bash
set -euo pipefail

printf 'GNOME Shell: '; gnome-shell --version
printf 'User Themes: '; gnome-extensions info user-theme@gnome-shell-extensions.gcampax.github.com | sed -n 's/^  State: / /p'
printf 'Dash to Dock: '; gnome-extensions info dash-to-dock@micxgx.gmail.com | sed -n 's/^  State: / /p'
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

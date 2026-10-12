#!/usr/bin/env bash
set -euo pipefail

theme=WhiteSur-GNOME50-Dark
user_theme=user-theme@gnome-shell-extensions.gcampax.github.com
dock=dash-to-dock@micxgx.gmail.com
test -f "$HOME/.themes/$theme/gnome-shell/gnome-shell.css" || { echo "Run ./install-theme.sh first" >&2; exit 1; }
for extension in "$user_theme" "$dock"; do
  gnome-extensions info "$extension" >/dev/null || { echo "Install GNOME extension: $extension" >&2; exit 1; }
done

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/whitesur-gnome/backups"
backup="$state_dir/$(date -u +%Y%m%dT%H%M%SZ)"
umask 077
mkdir -p "$backup"
dconf dump /org/gnome/shell/ > "$backup/shell.dconf"
dconf dump /org/gnome/desktop/wm/ > "$backup/wm.dconf"
dconf dump /org/gnome/desktop/interface/ > "$backup/interface.dconf"
dconf dump /org/gnome/desktop/background/ > "$backup/background.dconf"
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > "$backup/media-keys.dconf"
printf '%s\n' "$backup" > "$state_dir/latest"

gnome-extensions disable background-logo@fedorahosted.org 2>/dev/null || true
gnome-extensions enable "$user_theme"
gnome-extensions enable "$dock"
gsettings set org.gnome.shell.extensions.user-theme name "$theme"
gsettings set org.gnome.desktop.interface gtk-theme "$theme"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.wm.preferences theme "$theme"
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
if test -d "$HOME/.local/share/icons/WhiteSur-dark"; then gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur-dark'; fi
if test -d "$HOME/.local/share/icons/WhiteSur-cursors"; then gsettings set org.gnome.desktop.interface cursor-theme 'WhiteSur-cursors'; fi

schema=org.gnome.shell.extensions.dash-to-dock
gsettings set "$schema" dock-position 'BOTTOM'
gsettings set "$schema" extend-height false
gsettings set "$schema" always-center-icons true
gsettings set "$schema" autohide true
gsettings set "$schema" intellihide true
gsettings set "$schema" dash-max-icon-size 52
gsettings set "$schema" transparency-mode 'FIXED'
gsettings set "$schema" background-opacity 0.72
gsettings set "$schema" running-indicator-style 'DOTS'
gsettings set "$schema" show-trash false
gsettings set "$schema" show-mounts false
gsettings set "$schema" click-action 'cycle-windows'

gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super><Shift>s', '<Super><Shift>4', '<Super><Shift>3', 'Print']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['XF86Keyboard']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Shift>XF86Keyboard']"
if test -x "$HOME/.local/bin/whitesur-spotlight"; then
  gsettings set org.gnome.settings-daemon.plugins.media-keys search "['XF86Search']"
else
  gsettings set org.gnome.settings-daemon.plugins.media-keys search "['<Super>space']"
fi
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>m', '<Super>h']"
gsettings set org.gnome.desktop.wm.keybindings close "['<Alt>F4', '<Super>w']"
gsettings set org.gnome.shell.keybindings toggle-overview "['<Control>Up']"

wallpaper="$HOME/.local/share/wallpapers/WhiteSur-dark/contents/images/3840x2160.jpg"
if test -f "$wallpaper"; then
  gsettings set org.gnome.desktop.background picture-uri "file://$wallpaper"
  gsettings set org.gnome.desktop.background picture-uri-dark "file://$wallpaper"
fi

echo "GNOME WhiteSur configured. Private backup: $backup"

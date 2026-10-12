#!/usr/bin/env bash
set -euo pipefail

command -v rofi >/dev/null || { echo 'Install the Fedora rofi package first' >&2; exit 1; }
repo_dir="$(cd -- "$(dirname -- "$0")" && pwd)"
config_dir="$HOME/.config/whitesur-gnome"
launcher="$HOME/.local/bin/whitesur-spotlight"
key_path=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/whitesur-spotlight/
mkdir -p "$config_dir" "$(dirname "$launcher")"
install -m 644 "$repo_dir/whitesur-search.rasi" "$config_dir/spotlight.rasi"
cat > "$launcher" <<'EOF'
#!/bin/sh
# GNOME Wayland does not implement the layer-shell protocol required by
# Rofi's Wayland backend. Its XCB backend works through GNOME's XWayland.
unset WAYLAND_DISPLAY
exec /usr/bin/rofi -show drun -show-icons -theme "$HOME/.config/whitesur-gnome/spotlight.rasi"
EOF
chmod 755 "$launcher"

existing="$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)"
updated="$(python3 - "$existing" "$key_path" <<'PY'
import ast
import sys
raw, path = sys.argv[1:]
paths = ast.literal_eval(raw.removeprefix('@as '))
if path not in paths:
    paths.append(path)
print(repr(paths))
PY
)"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$updated"
binding="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$key_path"
gsettings set "$binding" name 'WhiteSur Search'
gsettings set "$binding" command "$launcher"
gsettings set "$binding" binding '<Super>space'
gsettings set org.gnome.settings-daemon.plugins.media-keys search "['XF86Search']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['XF86Keyboard']"
echo 'Super+Space now opens the WhiteSur app finder.'

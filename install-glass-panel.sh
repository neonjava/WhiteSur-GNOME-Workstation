#!/usr/bin/env bash
set -euo pipefail

source_theme="$HOME/.themes/WhiteSur-GNOME50-Dark/gnome-shell"
target_theme="$HOME/.themes/WhiteSur-GNOME50-Glass/gnome-shell"
test -f "$source_theme/gnome-shell.css" || { echo 'Install the WhiteSur GNOME 50 theme first' >&2; exit 1; }
mkdir -p "$(dirname "$target_theme")"
if ! test -d "$target_theme"; then cp -a "$source_theme" "$target_theme"; fi
cat > "$(dirname "$target_theme")/index.theme" <<'EOF'
[Desktop Entry]
Type=X-GNOME-Metatheme
Name=WhiteSur-GNOME50-Glass

[X-GNOME-Metatheme]
GtkTheme=WhiteSur-GNOME50-Dark
MetacityTheme=WhiteSur-GNOME50-Dark
IconTheme=WhiteSur-dark
CursorTheme=WhiteSur-cursors
ButtonLayout=close,minimize,maximize:
EOF

python3 - "$target_theme/gnome-shell.css" <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
marker = '/* WhiteSur GNOME glass panel overrides */'
css = path.read_text().split(marker)[0].rstrip()
css += '\n\n' + marker + '''
#panel, #panel.light-panel {
  background-color: transparent !important;
  color: #f7f8fc !important;
  box-shadow: none !important;
}
#panel .panel-button,
#panel .panel-button StLabel,
#panel .panel-button .system-status-icon,
#panel .panel-button .app-menu-icon > StIcon,
#panel .panel-button .popup-menu-arrow {
  color: #f7f8fc !important;
  text-shadow: 0 1px 2px rgba(20, 25, 45, 0.45) !important;
  icon-shadow: 0 1px 2px rgba(20, 25, 45, 0.45) !important;
}
#panel .panel-button:hover,
#panel .panel-button:focus,
#panel .panel-button:checked,
#panel .panel-button:active {
  background-color: rgba(255, 255, 255, 0.17) !important;
  color: #ffffff !important;
}
#panel .panel-corner {
  -panel-corner-background-color: transparent;
}
'''
path.write_text(css)
PY

extension_dir="$HOME/.local/share/gnome-shell/extensions/blur-my-shell@aunetx"
if ! test -f "$extension_dir/metadata.json"; then
  zip="$(mktemp --suffix=.zip)"
  trap 'rm -f -- "$zip"' EXIT
  curl -fsSL 'https://extensions.gnome.org/download-extension/blur-my-shell@aunetx.shell-extension.zip?version_tag=76297' -o "$zip"
  gnome-extensions install --force "$zip"
fi

schema_dir="$extension_dir/schemas"
GSETTINGS_SCHEMA_DIR="$schema_dir" gsettings set org.gnome.shell.extensions.blur-my-shell.panel style-panel 0
GSETTINGS_SCHEMA_DIR="$schema_dir" gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur true
GSETTINGS_SCHEMA_DIR="$schema_dir" gsettings set org.gnome.shell.extensions.blur-my-shell.panel override-background true
GSETTINGS_SCHEMA_DIR="$schema_dir" gsettings set org.gnome.shell.extensions.blur-my-shell.panel force-light-text false
python3 - <<'PY'
import ast
import subprocess

schema = 'org.gnome.shell'
key = 'enabled-extensions'
raw = subprocess.check_output(['gsettings', 'get', schema, key], text=True).strip()
extensions = ast.literal_eval(raw.removeprefix('@as '))
uuid = 'blur-my-shell@aunetx'
if uuid not in extensions:
    extensions.append(uuid)
    subprocess.run(['gsettings', 'set', schema, key, str(extensions)], check=True)
PY
gsettings set org.gnome.shell.extensions.user-theme name 'WhiteSur-GNOME50-Glass'
echo 'Transparent panel theme selected. Log out and back into GNOME to load the blur extension.'

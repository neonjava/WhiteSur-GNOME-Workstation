#!/usr/bin/env bash
set -euo pipefail

command -v code >/dev/null || { echo 'VS Code is not installed' >&2; exit 1; }
data_dir="$HOME/.local/share/whitesur-gnome/vscode-data"
settings="$data_dir/User/settings.json"
launcher="$HOME/.local/bin/code-gnome-whitesur"
desktop="$HOME/.local/share/applications/code-gnome-whitesur.desktop"
mkdir -p "$(dirname "$settings")" "$(dirname "$launcher")" "$(dirname "$desktop")"

if ! test -e "$settings"; then
  python3 - "$HOME/.config/Code/User/settings.json" "$settings" <<'PY'
import json
import pathlib
import sys

source, target = map(pathlib.Path, sys.argv[1:])
settings = json.loads(source.read_text()) if source.is_file() else {}
settings['window.menuBarVisibility'] = 'hidden'
target.write_text(json.dumps(settings, indent=2) + '\n')
PY
fi

cat > "$launcher" <<'EOF'
#!/bin/sh
exec /usr/bin/code --user-data-dir "$HOME/.local/share/whitesur-gnome/vscode-data" --extensions-dir "$HOME/.vscode/extensions" "$@"
EOF
chmod 755 "$launcher"
cat > "$desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Visual Studio Code (WhiteSur)
Comment=VS Code with a GNOME-only hidden in-window menu
Exec=$launcher %F
Icon=code
Categories=Development;IDE;
MimeType=text/plain;
Terminal=false
StartupNotify=true
EOF
echo 'Installed VS Code (WhiteSur). Open this launcher in GNOME; the existing VS Code process is unchanged.'

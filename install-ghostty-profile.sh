#!/usr/bin/env bash
set -euo pipefail

command -v ghostty >/dev/null || { echo 'Ghostty is not installed' >&2; exit 1; }
config_dir="$HOME/.config/gnome-whitesur/ghostty"
launcher="$HOME/.local/bin/ghostty-gnome-whitesur"
desktop="$HOME/.local/share/applications/ghostty-gnome-whitesur.desktop"
mkdir -p "$config_dir" "$(dirname "$launcher")" "$(dirname "$desktop")"
if test -f "$HOME/.config/ghostty/config" && ! test -f "$config_dir/config"; then
  while IFS= read -r line || test -n "$line"; do
    case "$line" in
      'config-file = ?~/.config/ghostty/'*) ;;
      *) printf '%s\n' "$line" ;;
    esac
  done < "$HOME/.config/ghostty/config" > "$config_dir/config"
fi
if ! test -f "$config_dir/config"; then : > "$config_dir/config"; fi
if ! grep -q '^# WhiteSur GNOME profile$' "$config_dir/config"; then
  cat >> "$config_dir/config" <<'EOF'

# WhiteSur GNOME profile
theme = Catppuccin Mocha
keybind = super+c=copy_to_clipboard:mixed
keybind = super+v=paste_from_clipboard
keybind = super+t=new_tab
keybind = super+n=new_window
keybind = super+q=quit
EOF
fi
cat > "$launcher" <<'EOF'
#!/bin/sh
export XDG_CONFIG_HOME="$HOME/.config/gnome-whitesur"
exec /usr/bin/ghostty "$@"
EOF
chmod 755 "$launcher"
cat > "$desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Ghostty (WhiteSur)
Comment=Ghostty with GNOME-only colors and shortcuts
Exec=$launcher
Icon=com.mitchellh.ghostty
Categories=System;TerminalEmulator;
Terminal=false
StartupNotify=true
EOF
XDG_CONFIG_HOME="$HOME/.config/gnome-whitesur" ghostty +validate-config
echo 'Installed Ghostty (WhiteSur) launcher; original Ghostty config unchanged.'

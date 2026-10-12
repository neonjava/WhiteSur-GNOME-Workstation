#!/usr/bin/env bash
set -euo pipefail

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/whitesur-gnome/backups"
test -f "$state_dir/latest" || { echo 'No backup recorded by apply.sh' >&2; exit 1; }
backup="$(cat "$state_dir/latest")"
case "$backup" in "$state_dir"/*) ;; *) echo 'Invalid backup path' >&2; exit 1;; esac
for section in shell wm interface background media-keys; do
  test -f "$backup/$section.dconf" || { echo "Missing backup: $section" >&2; exit 1; }
done
for section in shell wm interface background media-keys; do
  case "$section" in
    shell) path=/org/gnome/shell/ ;;
    wm) path=/org/gnome/desktop/wm/ ;;
    interface) path=/org/gnome/desktop/interface/ ;;
    background) path=/org/gnome/desktop/background/ ;;
    media-keys) path=/org/gnome/settings-daemon/plugins/media-keys/ ;;
  esac
  dconf reset -f "$path"
  dconf load "$path" < "$backup/$section.dconf"
done
echo 'Restored GNOME settings. Log out and back in to finish.'

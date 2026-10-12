#!/usr/bin/env bash
set -euo pipefail

ref=d5782652d412137e26fb8ff55b55a5572e4c6995
workdir="$(mktemp -d)"
trap 'rm -r -- "$workdir"' EXIT
git clone --quiet --no-checkout https://github.com/vinceliuice/WhiteSur-gtk-theme.git "$workdir"
git -C "$workdir" checkout --quiet "$ref"
(cd "$workdir" && ./install.sh -n WhiteSur-GNOME50 -c dark -t default -o normal --shell -i apple)
test -f "$HOME/.themes/WhiteSur-GNOME50-Dark/gnome-shell/gnome-shell.css"
printf 'Installed WhiteSur-GNOME50-Dark in %s/.themes\n' "$HOME"

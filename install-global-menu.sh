#!/usr/bin/env bash
set -euo pipefail

ref=466419282f589be9afe4df6a9d204470fea65ec8
uuid=global-menu@unmade.space
target="$HOME/.local/share/gnome-shell/extensions/$uuid"
if ! test -d "$target"; then
  workdir="$(mktemp -d)"
  trap 'rm -r -- "$workdir"' EXIT
  git clone --quiet --no-checkout https://github.com/Unmade760/orbit-global-menu.git "$workdir"
  git -C "$workdir" checkout --quiet "$ref"
  mkdir -p "$(dirname "$target")"
  cp -a "$workdir/$uuid" "$target"
fi
test -f "$target/metadata.json"
glib-compile-schemas "$target/schemas"

existing="$(gsettings get org.gnome.shell enabled-extensions)"
updated="$(python3 - "$existing" "$uuid" <<'PY'
import ast
import sys
raw, uuid = sys.argv[1:]
extensions = ast.literal_eval(raw.removeprefix('@as '))
if uuid not in extensions:
    extensions.append(uuid)
print(repr(extensions))
PY
)"
gsettings set org.gnome.shell enabled-extensions "$updated"
echo 'Orbit Global Menu is staged. Log out and back in to load it on GNOME Wayland.'

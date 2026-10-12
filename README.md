# WhiteSur GNOME Workstation

A small Fedora GNOME 50 setup for a Mac-inspired desktop. It uses the upstream [WhiteSur GTK theme](https://github.com/vinceliuice/WhiteSur-gtk-theme), Fedora's User Themes and Dash to Dock extensions, and GNOME's own shortcuts and gestures. This repository contains configuration scripts only; no WhiteSur assets or personal configuration files are redistributed.

## What it configures

- WhiteSur dark GTK and GNOME Shell theme, left-side window buttons, dark appearance, WhiteSur icons and cursors when installed.
- Bottom centered Dash to Dock with autohide, running indicators, and app favorites.
- `Super+Space` for GNOME search, `Super+Tab` for app switching, `Ctrl+Up` for Overview, `Super+Shift+S` for the GNOME screenshot UI. GNOME natively uses three-finger horizontal swipes to change workspaces.
- Optional Ghostty launcher with a separate theme and Mac-style terminal shortcuts. The regular Ghostty config is untouched.

GNOME does not provide a macOS global application menu, and Linux apps do not universally interpret `Super` as Command. GTK4/libadwaita apps may keep their own styling. This is a GNOME desktop configuration, not macOS.

## Fedora 44 setup

1. Install `gnome-shell-extension-user-theme`, `gnome-shell-extension-dash-to-dock`, `gnome-tweaks`, `git`, and `ghostty` if wanted. Use Fedora packages. Keep GDM as the display manager.
2. Run `./install-theme.sh` in a GNOME session. It installs a pinned upstream WhiteSur theme into your own `~/.themes` under `WhiteSur-GNOME50-Dark`, leaving existing themes in place.
3. Run `./apply.sh`. It makes a local backup in `~/.local/state/whitesur-gnome/backups/` before changing GNOME settings. No backup is committed to this repository.
4. Optional: run `./install-ghostty-profile.sh` and pin **Ghostty (WhiteSur)** to the dock. It keeps the existing Ghostty config intact.
5. Log out and back in if the Shell theme or dock does not repaint immediately. Choose **GNOME** at GDM.
6. Run `./verify.sh` to inspect settings. Test screenshot and touchpad gestures with your physical keyboard and touchpad.

The scripts make no disk partition, bootloader, or GDM changes. They do not remove other desktop environments. `./rollback.sh` restores the GNOME settings captured before the most recent `apply.sh`; it does not uninstall packages or the upstream theme.

## Sources

- [WhiteSur GTK theme](https://github.com/vinceliuice/WhiteSur-gtk-theme) and its [license](https://github.com/vinceliuice/WhiteSur-gtk-theme/blob/master/COPYING)
- [GNOME touchpad gestures](https://help.gnome.org/gnome-help/touchscreen-gestures.html)
- [GNOME keyboard shortcuts](https://help.gnome.org/gnome-help/keyboard-shortcuts-set.html)
- [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)

The scripts in this repository are licensed under MIT; upstream WhiteSur artwork and code retain their own license.

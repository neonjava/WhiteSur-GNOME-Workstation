# WhiteSur GNOME Workstation

A small Fedora GNOME 50 setup for a Mac-inspired desktop. It uses the upstream [WhiteSur GTK theme](https://github.com/vinceliuice/WhiteSur-gtk-theme), Fedora's User Themes and Dash to Dock extensions, and GNOME's own shortcuts and gestures. This repository contains configuration scripts only; no WhiteSur assets or personal configuration files are redistributed.

## What it configures

- WhiteSur dark GTK and GNOME Shell theme, left-side window buttons, dark appearance, WhiteSur icons and cursors when installed.
- Bottom centered Dash to Dock with autohide, running indicators, and app favorites.
- `Super+Space` for the app finder after `install-launcher.sh`, `Super+Tab` for app switching, `Ctrl+Up` for Overview, `Super+Shift+S` for the GNOME screenshot UI. GNOME natively uses three-finger horizontal swipes to change workspaces.
- Optional Ghostty launcher with a separate theme and Mac-style terminal shortcuts. The regular Ghostty config is untouched.
- Spotlight-style application finder using Fedora's Rofi and `Super+Space`.
- Optional top-bar File/Edit/View menus using [Orbit Global Menu](https://github.com/Unmade760/orbit-global-menu) on GNOME 50.
- Optional light translucent top bar with [Blur my Shell](https://github.com/aunetx/blur-my-shell), scoped to GNOME Shell. The dark application theme stays in place.
- Optional **VS Code (WhiteSur)** launcher with its own user-data directory and a hidden in-window menu. It opens the same project files and uses the existing extensions directory; the original VS Code settings remain unchanged.

The launcher uses Rofi's XCB backend through GNOME's XWayland because GNOME Wayland does not provide the layer-shell protocol Rofi's native Wayland backend requires.

GNOME itself does not provide a macOS global application menu. Orbit supplies a shortcut-backed menu for VS Code and Ghostty, with actual exported menus only where the application provides one. Their in-window menus may remain visible. Linux apps do not universally interpret `Super` as Command. GTK4/libadwaita apps may keep their own styling. This is a GNOME desktop configuration, not macOS.

## Fedora 44 setup

1. Install `gnome-shell-extension-user-theme`, `gnome-shell-extension-dash-to-dock`, `gnome-tweaks`, `git`, and `ghostty` if wanted. Use Fedora packages. Keep GDM as the display manager.
2. Run `./install-theme.sh` in a GNOME session. It installs a pinned upstream WhiteSur theme into your own `~/.themes` under `WhiteSur-GNOME50-Dark`, leaving existing themes in place.
3. Run `./apply.sh`. It makes a local backup in `~/.local/state/whitesur-gnome/backups/` before changing GNOME settings. No backup is committed to this repository.
4. Install Fedora's `rofi` package, then run `./install-launcher.sh` for a Spotlight-style app finder on `Super+Space`.
5. Run `./install-global-menu.sh` to stage the top-bar menu extension. It uses a pinned upstream commit and does not install the optional menu daemon. **Log out and back in** to load it on GNOME Wayland.
6. Optional: run `./install-ghostty-profile.sh` and pin **Ghostty (WhiteSur)** to the dock. It keeps the existing Ghostty config intact. Run `./install-vscode-launcher.sh` and open **VS Code (WhiteSur)** to hide VS Code's duplicate in-window menu in GNOME. An already running VS Code window will retain its current menu until it is reopened through this launcher. The isolated instance has separate editor state and sign-ins.
7. Run `./install-glass-panel.sh` for the light translucent top bar and blur. **Log out and back into GNOME** to load the new Blur my Shell extension.
8. Run `./verify.sh` to inspect settings. Test the menus, app finder, screenshot, and touchpad gestures with your physical keyboard and touchpad.

The scripts make no disk partition, bootloader, or GDM changes. They do not remove other desktop environments. `./rollback.sh` restores the GNOME settings captured before the most recent `apply.sh`; it does not uninstall packages or the upstream theme.

## Sources

- [WhiteSur GTK theme](https://github.com/vinceliuice/WhiteSur-gtk-theme) and its [license](https://github.com/vinceliuice/WhiteSur-gtk-theme/blob/master/COPYING)
- [GNOME touchpad gestures](https://help.gnome.org/gnome-help/touchscreen-gestures.html)
- [GNOME keyboard shortcuts](https://help.gnome.org/gnome-help/keyboard-shortcuts-set.html)
- [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
- [Orbit Global Menu](https://github.com/Unmade760/orbit-global-menu)
- [Blur my Shell](https://github.com/aunetx/blur-my-shell)

The scripts in this repository are licensed under MIT; upstream WhiteSur artwork and code retain their own license.

#!/bin/sh
# Builds ghost-gdm.gresource: Ubuntu's Yaru login theme + blurred wallpaper + green accents.
# Install (sudo) and undo lines are printed at the end. Rebuild after changing the wallpaper.
set -e
here=$(cd "$(dirname "$0")" && pwd); src=/usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource
work=$(mktemp -d); cd "$work"
for r in $(gresource list "$src"); do mkdir -p "theme${r%/*}"; gresource extract "$src" "$r" > "theme$r"; done
cp ~/dotfiles/wallpaper/lock.png theme/org/gnome/shell/theme/ghost-login.png
cat >> theme/org/gnome/shell/theme/gdm.css <<'CSS'

/* ghost */
#lockDialogGroup { background: #0a0a0a url("resource:///org/gnome/shell/theme/ghost-login.png"); background-size: cover; background-position: center; }
.login-dialog StEntry:focus, .unlock-dialog StEntry:focus { border-color: #8fbf8f; box-shadow: inset 0 0 0 2px #8fbf8f; }
.login-dialog .modal-dialog-button-box .modal-dialog-button.default,
.login-dialog .login-dialog-button.default { background-color: #8fbf8f; color: #0a0a0a; }
.login-dialog .login-dialog-button.default:hover { background-color: #b6e3a8; }
CSS
{ echo '<?xml version="1.0" encoding="UTF-8"?><gresources><gresource prefix="/">'
  (cd theme && find . -type f | sed 's|^\./||' | while read -r f; do echo "<file>$f</file>"; done)
  echo '</gresource></gresources>'; } > theme.xml
glib-compile-resources --sourcedir=theme --target="$here/ghost-gdm.gresource" theme.xml
rm -rf "$work"
echo "built $here/ghost-gdm.gresource"
echo "install:  sudo install -m644 $here/ghost-gdm.gresource /usr/share/gnome-shell/theme/ghost-gdm.gresource && sudo update-alternatives --install /usr/share/gnome-shell/gdm-theme.gresource gdm-theme.gresource /usr/share/gnome-shell/theme/ghost-gdm.gresource 20"
echo "undo:     sudo update-alternatives --remove gdm-theme.gresource /usr/share/gnome-shell/theme/ghost-gdm.gresource"

#!/bin/sh
# Links each config folder into ~/.config. Existing ones are moved aside first.
set -e
cd "$(dirname "$0")"
here=$(pwd)
stamp=$(date +%Y%m%d-%H%M%S)

mkdir -p ~/.config
for t in i3 polybar kitty rofi picom dunst gammastep; do
  dest="$HOME/.config/$t"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.bak-$stamp"
    echo "moved your old $t to $dest.bak-$stamp"
  fi
  ln -sfn "$here/$t" "$dest"
  echo "linked $t"
done

# app theme: dark sage, Papirus icons, Bibata cursor (gtk ini for most apps, gsettings for GNOME ones)
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
ln -sf "$here/gtk/settings.ini" ~/.config/gtk-3.0/settings.ini
ln -sf "$here/gtk/settings.ini" ~/.config/gtk-4.0/settings.ini
gsettings set org.gnome.desktop.interface gtk-theme Yaru-sage-dark 2>/dev/null || true
gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark 2>/dev/null || true
gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Classic 2>/dev/null || true
mkdir -p ~/.icons/default && printf '[Icon Theme]\nInherits=Bibata-Modern-Classic\n' > ~/.icons/default/index.theme

chmod +x bin/* polybar/*.sh
[ -f wallpaper/wall.png ] && [ ! -f wallpaper/lock.png ] && bin/make-lock || true
[ -f wallpaper/wall.png ] || echo "no wallpaper yet: put one at $here/wallpaper/wall.png, then run bin/make-lock"
echo "done. log out and pick i3 at the login screen."

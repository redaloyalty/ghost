#!/bin/sh
# Links each config folder into ~/.config. Existing ones are moved aside first.
set -e
cd "$(dirname "$0")"
here=$(pwd)
stamp=$(date +%Y%m%d-%H%M%S)

mkdir -p ~/.config
for t in i3 polybar kitty rofi picom dunst; do
  dest="$HOME/.config/$t"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.bak-$stamp"
    echo "moved your old $t to $dest.bak-$stamp"
  fi
  ln -sfn "$here/$t" "$dest"
  echo "linked $t"
done

chmod +x bin/* polybar/*.sh
[ -f wallpaper/wall.png ] && [ ! -f wallpaper/lock.png ] && bin/make-lock || true
[ -f wallpaper/wall.png ] || echo "no wallpaper yet: put one at $here/wallpaper/wall.png, then run bin/make-lock"
echo "done. log out and pick i3 at the login screen."

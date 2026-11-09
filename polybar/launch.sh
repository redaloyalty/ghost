#!/bin/sh
# style: hud (default) | islands | bottom | hidden  - set with bin/bar-style
style=$(cat ~/.config/ghost/bar-style 2>/dev/null || echo hud)
# polybar can hang on exit (tray), so give it a second, then force it
pkill -x polybar
for i in 1 2 3 4 5; do pgrep -x polybar >/dev/null || break; sleep 0.2; done
pkill -9 -x polybar 2>/dev/null
sleep 0.3
primary=$(polybar --list-monitors | grep primary | cut -d: -f1)
for m in $(polybar --list-monitors | cut -d: -f1); do
  if [ "$m" = "$primary" ]; then
    case $style in
      islands) for b in isl-left isl-center isl-right; do MONITOR=$m polybar --reload $b & done ;;
      bottom)  MONITOR=$m polybar --reload bottom & ;;
      *)       MONITOR=$m polybar --reload main & ;;
    esac
  else
    case $style in
      bottom) MONITOR=$m polybar --reload bottom-side & ;;
      *)      MONITOR=$m polybar --reload side & ;;
    esac
  fi
done
# floating islands reserve no space themselves, so make room at the top
(sleep 1.2; ~/dotfiles/bin/gaps-fit) &  # after i3 finishes a reload
if [ "$style" = hidden ]; then sleep 1.5; polybar-msg cmd hide >/dev/null 2>&1; fi

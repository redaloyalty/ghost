#!/bin/sh
pkill -x polybar
while pgrep -x polybar >/dev/null; do sleep 0.2; done
for m in $(polybar --list-monitors | cut -d: -f1); do
  if [ "$m" = "$(polybar --list-monitors | grep primary | cut -d: -f1)" ]; then
    MONITOR=$m polybar --reload main &
  else
    MONITOR=$m polybar --reload side &
  fi
done

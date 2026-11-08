#!/bin/sh
# bar module: mind status. loaded model in green, idle in bone, down dimmed.
api="http://${MIND_HOST:-192.168.1.10}:11434"
if ! curl -s --max-time 1 "$api/api/version" >/dev/null; then
  echo "%{F#7d8079}󰧑 mind off%{F-}"; exit
fi
m=$(curl -s --max-time 1 "$api/api/ps" | jq -r '.models[0].name // empty' | cut -d: -f1)
[ -n "$m" ] && echo "%{F#8fbf8f}󰧑 $m%{F-}" || echo "󰧑 mind"

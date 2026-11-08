#!/bin/sh
# HUD readout for the laptop LLM. loaded = green, idle = bone, down = dim.
[ -f ~/.config/mind/host ] && MIND_HOST=${MIND_HOST:-$(cat ~/.config/mind/host)}
[ -z "$MIND_HOST" ] && { echo "%{F#7d8079}MIND OFF%{F-}"; exit; }
api="http://$MIND_HOST:11434"
if ! curl -s --max-time 1 "$api/api/version" >/dev/null; then
  echo "%{F#7d8079}MIND OFF%{F-}"; exit
fi
m=$(curl -s --max-time 1 "$api/api/ps" | jq -r '.models[0].name // empty' | cut -d: -f1 | tr a-z A-Z)
[ -n "$m" ] && echo "%{F#7d8079}MIND%{F-} %{F#8fbf8f}● $m%{F-}" || echo "%{F#7d8079}MIND%{F-} ○ IDLE"

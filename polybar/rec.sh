#!/bin/sh
# red REC on the bar while bin/rec is running
[ -f /tmp/ghost-rec.pid ] && kill -0 "$(cat /tmp/ghost-rec.pid)" 2>/dev/null && echo "%{F#c2564a}● REC%{F-}" || echo ""

#!/usr/bin/env bash

pkill polybar
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 1; done

echo "---" | tee -a /tmp/polybar.log

for m in $(polybar --list-monitors | cut -d: -f1); do
  MONITOR="$m" polybar theoroi 2>&1 | tee -a /tmp/polybar.log &
done
disown

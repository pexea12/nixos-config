#!/usr/bin/env bash

pkill polybar

echo "---" | tee -a /tmp/polybar.log
polybar theoroi 2>&1 | tee -a /tmp/polybar.log & disowns

#!/usr/bin/env bash

# Wrapper: ~/.local/bin/brave-wayland

# Due to this issue https://github.com/hyprwm/Hyprland/discussions/11961
# We have to create a new desktop entry file for brave to --disable-features=WaylandWpColorManagerV1
# Probably do the same for all Chromium-based browsers

BRAVE_BIN="$(command -v brave || command -v brave-browser || command -v brave-bin)"
if [ -z "$BRAVE_BIN" ]; then
  echo "Error: Brave binary not found in PATH." >&2
  exit 1
fi

if [ "${XDG_SESSION_TYPE:-}" = "wayland" ]; then
  exec "$BRAVE_BIN" --disable-features=WaylandWpColorManagerV1 "$@"
else
  exec "$BRAVE_BIN" "$@"
fi

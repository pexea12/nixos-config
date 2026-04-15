#!/usr/bin/env bash
set -euo pipefail

LATEST=$(curl -s "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/n/nordvpn/" \
  | grep -oP 'nordvpn_\K[0-9]+\.[0-9]+\.[0-9]+(?=_amd64\.deb)' \
  | sort -V | tail -1)

echo "Updating nordvpn to $LATEST"
nix-update nordvpn --flake --version "$LATEST"

{ config, pkgs, lib, ... }:

{
  # useRoutingFeatures = "both" enables:
  # - IP forwarding (for acting as exit node/subnet router)
  # - Loose reverse path filtering (for using exit nodes)
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  # Required for exit node functionality
  # See https://wiki.nixos.org/wiki/Tailscale
  networking.firewall.checkReversePath = "loose";
}

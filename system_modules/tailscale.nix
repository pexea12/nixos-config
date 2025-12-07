{ config, pkgs, lib, ... }:

{
  # Tailscale VPN service
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both"; # Enable as both client and subnet router/exit node
  };

  # Firewall configuration for Tailscale
  networking.firewall = {
    allowedUDPPorts = [ 41641 ]; # Tailscale UDP port
    checkReversePath = "loose"; # Required for Tailscale exit node functionality
  };

  # Enable IP forwarding for routing traffic through this machine
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}

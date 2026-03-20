{ pkgs, ... }:

{
  networking = {
    hostName = "karpalo";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 8000 8888 ];
  };

  # Restart NetworkManager after suspend/resume to recover WiFi connectivity.
  # On s2idle (the only sleep state available on this hardware), some WiFi
  # drivers fail to properly reinitialize after resume, causing disconnection
  # or loss of internet access.
  systemd.services.nm-restart-on-resume = {
    description = "Restart NetworkManager after suspend/resume";
    wantedBy = [ "post-suspend.target" ];
    after = [ "post-suspend.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl restart NetworkManager";
    };
  };
}

{ config, pkgs, lib, configDir, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    systemd.enable = false;
  };

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
  services.hyprpaper.enable = true;

  home.packages = with pkgs; [
    rose-pine-hyprcursor
    wofi

    ## Screenshot
    grim
    slurp
    wl-clipboard
  ];

  xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/hypr";
  };
}

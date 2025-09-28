{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.udisks2.enable = true;
  services.gvfs.enable = true;

  networking = {
    hostName = "karpalo";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 8000 8888 ];
  };

  time.timeZone = "Europe/Helsinki";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "ibus";
      ibus = {
        engines = [ pkgs.ibus-engines.bamboo ];
      };
    };
  };

  programs.hyprland.enable = true;
  programs.waybar.enable = true;
  services.displayManager.ly.enable = true;
  services.displayManager.defaultSession = "hyprland";

  # Recommended: proper screen sharing/portals for Hyprland.
  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

  # Optional QoL for Wayland apps (Chromium/Electron use Wayland by default).
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  powerManagement.enable = true;
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "suspend";
  };

  programs.zsh.enable = true; # Details zsh config is in home.nix
  users.users.pexea12 = {
    isNormalUser = true;
    description = "pexea12";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    neovim
    ghostty
    htop
    fastfetch
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "weekly";
  };

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/input.nix
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

  services.displayManager.ly.enable = true;
  services.displayManager.defaultSession = "none+i3";

  # Enable X11 windowing system
  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
    };
  };

  # Automatic monitor detection (sets up udev rules and systemd services)
  services.autorandr.enable = true;

  # Required for XDG portals when using home-manager as NixOS module
  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Blueman - GUI Bluetooth manager
  services.blueman.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Input configuration is now in modules/input.nix

  powerManagement.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };

  programs.zsh.enable = true; # Details zsh config is in home.nix
  users.users.pexea12 = {
    isNormalUser = true;
    description = "pexea12";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  programs.neovim = {
    defaultEditor = true;
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    ghostty
    htop
    fastfetch

    # Input
    libinput
    usbutils
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

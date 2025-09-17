{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "karpalo";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Helsinki";

  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # TODO: Disable xserver
  services.xserver.enable = true;

  # TODO: Update sddm to ly
  services.displayManager.sddm.enable = true;
  # TODO: Update plasma6 to hyprland
  services.desktopManager.plasma6.enable = true;
  programs.hyprland.enable = true;
  programs.waybar.enable = true;

  services.displayManager.defaultSession = "hyprland";

  # services.displayManager.sddm.wayland.enable = true;

  # Recommended: proper screen sharing/portals for Hyprland.
  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

  # Optional QoL for Wayland apps (Chromium/Electron use Wayland by default).
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.users.pexea12 = {
    isNormalUser = true;
    description = "pexea12";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    ghostty
    htop
    fastfetch
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";

  # TODO: Enable autoUpgrade
  # TODO: Enable autoClean and garbageCollection
  # TODO: Set max number of generations or max time to live
  # nix = {
  #   settings.auto-optimise-store = true;
  #   gc = {
  #     automatic = true;
  #     dates = "weekly";
  #     options = "--delete-older-than 7d";
  #   };
  # }
}

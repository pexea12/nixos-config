{ config, pkgs, lib, configDir, ... }:

{
  # Cursor theme configuration
  home.pointerCursor = {
    name = "breeze_cursors";
    package = pkgs.kdePackages.breeze;
    size = 24;
    x11.enable = true;
    x11.defaultCursor = "left_ptr";
  };

  # Idle management
  services.xidlehook = {
    enable = true;
    detect-sleep = true;
    not-when-audio = true;
    not-when-fullscreen = true;
    timers = [
      {
        delay = 150; # 2.5 minutes
        command = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
        canceller = "${pkgs.brightnessctl}/bin/brightnessctl -r";
      }
      {
        delay = 300; # 5 minutes
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        delay = 330; # 5.5 minutes
        command = "${pkgs.xset}/bin/xset dpms force off";
        canceller = "${pkgs.xset}/bin/xset dpms force on && ${pkgs.brightnessctl}/bin/brightnessctl -r";
      }
      {
        delay = 1800; # 30 minutes
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };

  home.packages = with pkgs; [
    # Cursor theme
    kdePackages.breeze

    # Wallpaper setter
    feh

    # Screenshot tools
    maim
    xclip

    # Launcher
    rofi

    # Screen locker with nice effects
    i3lock-color

    # Notification daemon
    dunst

    # Compositor for transparency and effects
    picom
  ];

  xdg.configFile."i3" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/i3";
  };

  xdg.configFile."dunst" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/dunst";
  };

  xdg.configFile."picom" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/picom";
  };

  xdg.configFile."rofi" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/rofi";
  };
}

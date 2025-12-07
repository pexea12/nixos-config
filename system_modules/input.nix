{ config, pkgs, lib, ... }:

{
  services.xserver = {
    xkb.layout = "us";
    xkb.options = "compose:ralt";

    autoRepeatDelay = 200;
    autoRepeatInterval = 30;
  };

  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
    };
  };

  services.keyd = {
    enable = true;
    keyboards."orange-keyboard" = {
      ids = [ "32c2:0018:c9343c6c" ];
      settings = {
        main = {
          leftalt = "leftmeta";
          leftmeta = "leftalt";
          rightmeta = "rightalt";
        };
      };
    };
  };

  # Input method (Vietnamese - ibus-bamboo)
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus = {
      engines = with pkgs.ibus-engines; [ bamboo ];
    };
  };
}

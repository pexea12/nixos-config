{ config, pkgs, ... }:

let
  # Monitor EDID fingerprints for automatic detection
  thinkPadScreen = "00ffffffffffff0030aec6410000000000220104a51e137803c472985d588e2621515400000001010101010101010101010101010101333f80dc70b03c40302036002ebc1000001a000000fd00283c4c4c10010a2020202020200000000f00d10a3cd10a3c280a0409e53f0c000000fe004e5631343057554d2d4e34390a00f6";
  thinkVisionScreen = "00ffffffffffff0030aef361434e41462f1f0104a55021783a62f5aa524ca3260f5054a1080081008180950081c0b300d1c001010101e77c70a0d0a0295030203a001d4e3100001a000000ff005633303846414e430a20202020000000fd0030641e9437010a202020202020000000fc004c454e20543334772d32300a2001e3020321f14e010304131f120211900f0e1d1e5a230907078301000065030c002000662156aa51001e30468f33001d4e3100001e6a5e00a0a0a02950302035001d4e3100001e226870a0d0a02950302035001d4e3100001acd4600a0a0381f4030203a001d4e3100001a0000000000000000000000000000000000000000000078";
in
{
  home.packages = with pkgs; [
    arandr  # GUI tool for configuring displays
  ];

  # Automatic monitor detection and configuration
  # Note: System-level autorandr service must be enabled in configuration.nix
  # with: services.autorandr.enable = true;
  programs.autorandr = {
    enable = true;

    profiles = {
      # Laptop only (no external monitor)
      "laptop" = {
        fingerprint = {
          eDP-1 = thinkPadScreen;
        };
        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            mode = "1920x1200";
            position = "0x0";
            rate = "60.00";
          };
        };
      };

      # Docked with external monitor - dual screen setup
      "docked" = {
        fingerprint = {
          eDP-1 = thinkPadScreen;
          DP-2 = thinkVisionScreen;
        };
        config = {
          DP-2 = {
            enable = true;
            primary = true;
            mode = "3440x1440";
            position = "0x0";
            rate = "59.97";
          };
          eDP-1 = {
            enable = true;
            mode = "1920x1200";
            position = "3440x120";  # Position to the right of external monitor
            rate = "60.00";
          };
        };
      };
    };
  };
}

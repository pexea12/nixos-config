{ config, pkgs, ... }:

{
  services.tlp = {
    enable = true;
    settings = {
      # Battery charge thresholds (ThinkPad specific)
      # Start charging when below 75%, stop at 85%
      # This preserves battery health for daily use
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 85;

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";  # Default governor (TLP will override)
  };

  environment.systemPackages = with pkgs; [
    powertop
    acpi
  ];
}

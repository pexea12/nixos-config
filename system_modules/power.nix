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

      # Exclude Bluetooth from USB autosuspend to prevent disconnections.
      # NOTE: this doesn't work for the onboard MediaTek MT7925 combo card
      # (idVendor=0e8d idProduct=e025): it's a composite USB device, so the
      # Bluetooth-class descriptor (e0/01/01) is on an interface, not the
      # device itself, and this check only looks at the device-level class
      # (which reports ef/02/01 here). Kept for other USB BT dongles.
      USB_EXCLUDE_BTUSB = 1;

      # Exact-match denylist as a workaround for the above: TLP matches this
      # by idVendor:idProduct directly, so the composite-device class check
      # doesn't matter. Without this the BT link autosuspends every 2s and
      # the mouse drops with "ACL packet for unknown connection handle" every
      # 10-15 minutes. (A udev rule setting ATTR{power/control}="on" doesn't
      # work either: TLP's own udev rule (85-tlp.rules) re-runs this same
      # exclusion logic on every USB add event via RUN+=, which always
      # executes after other rules' ATTR assignments regardless of filename
      # order, so it silently stomps any external override.)
      USB_DENYLIST = "0e8d:e025";
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

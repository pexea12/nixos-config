{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # GUI audio control for PipeWire
    pavucontrol
  ];
}

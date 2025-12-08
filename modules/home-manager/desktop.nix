# Home-manager desktop module
# Automatically configures home-manager based on the NixOS desktop choice
{ config, lib, pkgs, osConfig, ... }:

with lib;

let
  # Read the desktop choice from NixOS config
  desktop = osConfig.mySystem.desktop.environment or "plasma";
in {
  config = mkMerge [
    # Plasma-specific home configuration
    (mkIf (desktop == "plasma") {
      programs.plasma.enable = true;
      wayland.windowManager.sway.enable = false;
      programs.waybar.enable = false;
    })

    # Sway-specific home configuration
    (mkIf (desktop == "sway") {
      programs.plasma.enable = false;
      wayland.windowManager.sway.enable = true;
      programs.waybar.enable = true;
    })

    # No desktop - disable everything
    (mkIf (desktop == "none") {
      programs.plasma.enable = false;
      wayland.windowManager.sway.enable = false;
      programs.waybar.enable = false;
    })
  ];
}

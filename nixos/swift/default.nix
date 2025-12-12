# Swift laptop configuration
{ config, pkgs, inputs, ... }:

{
  imports = [
    ../shared
    ./hardware-configuration.nix
  ];

  networking.hostName = "swift";

  # Desktop environment: "plasma", "sway", or "none"
  mySystem.desktop.environment = "sway";

  # Swift-specific configuration goes here
  # Add any packages or settings specific to this laptop

  system.stateVersion = "25.05";
  hardware.bluetooth.enable = true;
}

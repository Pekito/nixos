# Zenbook laptop configuration
{ config, pkgs, inputs, ... }:

{
  imports = [
    ../shared
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.asus-battery
  ];

  networking.hostName = "zenbook";

  # Desktop environment: "plasma", "sway", or "none"
  mySystem.desktop.environment = "sway";

  # Zenbook-specific configuration goes here
  # Add any packages or settings specific to this laptop

  # Battery charge limit configuration
  hardware.asus.battery = {
    chargeUpto = 80;
    enableChargeUptoScript = true;
  };

  system.stateVersion = "25.05";
  hardware.bluetooth.enable = true;
}

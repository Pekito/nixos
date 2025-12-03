# Zenbook laptop configuration
{ config, pkgs, ... }:

{
  imports = [
    ../shared
    ./hardware-configuration.nix
  ];

  networking.hostName = "zenbook";

  # Zenbook-specific configuration goes here
  # Add any packages or settings specific to this laptop

  system.stateVersion = "25.05";
}

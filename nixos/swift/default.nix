# Swift laptop configuration
{ config, pkgs, inputs, ... }:

{
  imports = [
    ../shared
    ./hardware-configuration.nix
  ];

  networking.hostName = "swift";

  # Desktop environment: "plasma", "sway", or "none"
  mySystem.desktop.environment = "plasma";

  # Swift-specific configuration goes here
  # Add any packages or settings specific to this laptop

  # Fix audio: Force the correct profile for internal speakers
  # The Conexant CX11970 audio codec needs the Speaker profile to enable internal speakers
  services.pipewire.wireplumber.configPackages = [
    (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-alsa-swift-audio.conf" ''
      # Configure audio profile for Swift laptop internal speakers
      monitor.alsa.rules = [
        {
          matches = [
            {
              node.name = "~alsa_card.pci-0000_c1_00.6"
            }
          ]
          actions = {
            update-props = {
              api.alsa.use-acp = true
              device.profile = "HiFi (Mic1, Mic2, Speaker)"
            }
          }
        }
      ]
    '')
  ];

  system.stateVersion = "25.05";
  hardware.bluetooth.enable = true;
}

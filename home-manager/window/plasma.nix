# KDE Plasma configuration
{ inputs, config, pkgs, ... }:

{
  imports = [
    # Import plasma-manager
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  # Configure Plasma
  programs.plasma = {
    
    # Configure keyboard layout
    input.keyboard = {
      layouts = [
        {
          layout = "us";
          variant = "intl";
          displayName = "US Int";
        }
      ];
    };
  };
}

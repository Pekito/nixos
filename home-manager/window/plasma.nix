# KDE Plasma configuration
{ inputs, config, pkgs, ... }:

{
  imports = [
    # Import plasma-manager
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  # Configure Plasma
  programs.plasma = {
    enable = true;
    
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

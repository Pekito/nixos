# Fish shell configuration
{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    
    shellAliases = {
      ll = "ls -la";
      update = "sudo nixos-rebuild switch --flake ~/Documents/nixos-config";
      home-update = "sudo nixos-rebuild switch --flake ~/Documents/nixos-config";
    };

    shellInit = ''
      # Add any fish shell initialization here
    '';

    interactiveShellInit = ''
      # Disable fish greeting
      set -g fish_greeting

      # Set up any interactive shell config here
    '';

    plugins = [
      # You can add fish plugins here if needed
      # Example:
      # {
      #   name = "z";
      #   src = pkgs.fishPlugins.z.src;
      # }
    ];

    functions = {
      # Custom fish functions
      mkcd = ''
        mkdir -p $argv[1] && cd $argv[1]
      '';
    };
  };
}

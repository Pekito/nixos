# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # inputs.self.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    
    # Terminal configuration
    ./terminal
  ];

  # Note: nixpkgs configuration is disabled when home-manager.useGlobalPkgs = true
  # Overlays and config are managed at the NixOS level in nixos/shared/default.nix

  home = {
    username = "pedro-pires";
    homeDirectory = "/home/pedro-pires";
    
    # Install JetBrains Mono font
    packages = with pkgs; [
      jetbrains-mono
    ];
  };

  # Configure fonts
  fonts.fontconfig.enable = true;

  # VSCode configuration with JetBrains Mono (using new profiles syntax)
  programs.vscode = {
    enable = true;
    profiles.default.userSettings = {
      "editor.fontFamily" = "'JetBrains Mono', 'monospace'";
      "editor.fontSize" = 13;
      "editor.fontLigatures" = true;
      "terminal.integrated.fontFamily" = "'JetBrains Mono'";
      "terminal.integrated.fontSize" = 13;
    };
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}

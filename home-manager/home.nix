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
    
    # Window manager configuration (Plasma, Sway, etc.)
    ./window

    # Desktop module - automatically configures based on NixOS desktop choice
    ../modules/home-manager
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

    # Cedilla fix: Create .XCompose file for proper cedilla behavior
    # This replaces all occurrences of accented-c (ć/Ć) with cedilla-c (ç/Ç)
    # Based on: https://github.com/marcopaganini/gnome-cedilla-fix
    file.".XCompose".text = 
      let
        # Get the system compose file for the current locale
        systemCompose = builtins.readFile "${pkgs.xorg.libX11}/share/X11/locale/en_US.UTF-8/Compose";
        # Replace accented-c with cedilla-c
        # ć (U+0107) -> ç (U+00E7)
        # Ć (U+0106) -> Ç (U+00C7)
        fixedCompose = builtins.replaceStrings 
          ["ć" "Ć"] 
          ["ç" "Ç"] 
          systemCompose;
      in fixedCompose;
  };

  # Configure fonts
  fonts.fontconfig.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Pedro Luiz";
    userEmail = "p3dr0c4@live.com";
    lfs.enable = true;
    # Additional config options
    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";

  # Desktop environment (plasma/sway/none) is now configured automatically
  # based on mySystem.desktop.environment set in your NixOS host config
}

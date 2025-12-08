# Desktop environment module
# Allows easy switching between Plasma, Sway, or no desktop
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.mySystem.desktop;
in {
  options.mySystem.desktop = {
    environment = mkOption {
      type = types.enum [ "plasma" "sway" "none" ];
      default = "plasma";
      description = "Which desktop environment to use (plasma, sway, or none)";
    };
  };

  config = mkMerge [
    # Common settings for any graphical environment
    (mkIf (cfg.environment != "none") {
      # Display manager
      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.wayland.enable = true;
    })

    # Plasma-specific configuration
    (mkIf (cfg.environment == "plasma") {
      services.desktopManager.plasma6.enable = true;
      # Also enable Sway so it's available as an option in SDDM
      programs.sway.enable = true;
    })

    # Sway-specific configuration
    (mkIf (cfg.environment == "sway") {
      programs.sway.enable = true;
      services.desktopManager.plasma6.enable = false;
      
      # Optional: Use greetd instead of SDDM for a lighter setup
      # Uncomment below and set sddm.enable = false above if preferred
      # services.greetd = {
      #   enable = true;
      #   settings = {
      #     default_session = {
      #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
      #       user = "greeter";
      #     };
      #   };
      # };
    })

    # No desktop - just TTY
    (mkIf (cfg.environment == "none") {
      services.displayManager.sddm.enable = false;
      services.desktopManager.plasma6.enable = false;
      programs.sway.enable = false;
    })
  ];
}

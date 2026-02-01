# Shared configuration for all hosts
{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../../modules/nixos
  ];

  # Cedilla fix for US International keyboard layout
  # This makes '+c produce ç instead of ć
  # Using fcitx5 as the input method for all apps (including Chromium-based like Chrome, Slack)
  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    # For Chromium/Electron apps on Wayland
    GLFW_IM_MODULE = "fcitx";
  };

  # Configure nixpkgs with overlays since home-manager.useGlobalPkgs = true
  nixpkgs = {
    overlays = [
      # Add overlays from your flake
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users = {
      pedro-pires = import ../../home-manager/home.nix;
    };
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
    LC_CTYPE = lib.mkDefault "pt_BR.UTF-8"; # Fix ç in us-intl.
  };
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk   # GTK input module for better app integration
      ];
      settings = {
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us-intl";
            DefaultIM = "keyboard-us-intl";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-us-intl";
          };
          "GroupOrder" = {
            "0" = "Default";
          };
        };
      };
    };
  };

  # Desktop environment is now configured via mySystem.desktop.environment
  # Set it in your host-specific config (e.g., nixos/zenbook/default.nix)
  # Options: "plasma", "sway", "none"

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = lib.mkDefault "us";
    variant = lib.mkDefault "intl";
  };
  # Configure console keymap
  console.keyMap = "us-acentos";

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
          wireplumber.settings = { bluetooth.autoswitch-to-headset-profile = false }
        '')
      ];
    };
  };

  # Font configuration - using Inter as Windows 11-like default
  # Inter is an open-source font very similar to Windows 11's Segoe UI Variable
  fonts = {
    packages = with pkgs; [
      inter                  # Windows 11-like system font (Segoe UI alternative)
      noto-fonts             # Fallback for international characters
      noto-fonts-cjk-sans    # CJK support
      noto-fonts-color-emoji # Emoji support
    ];
    
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Inter" "Noto Sans" ];
        serif = [ "Noto Serif" ];
        monospace = [ "JetBrains Mono" "Noto Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
      # Subpixel rendering for sharper fonts (like Windows)
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
      hinting = {
        enable = true;
        style = "slight";  # Windows-like hinting
      };
      antialias = true;
    };
  };

  # Define a user account
  users.users.pedro-pires = {
    isNormalUser = true;
    description = "Pedro Pires";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
    shell = pkgs.fish;
  };


  # Common system packages
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    google-chrome
    vscode
    telegram-desktop
    keepassxc
    google-drive-ocamlfuse
    slack
    firefox
    nodejs-22_18
    hurl
    devenv
    tmux
    discord
    pavucontrol
    bluetui
    btop
    claude-code
    obs-studio
    dotnetCorePackages.dotnet_9.sdk
  ];
  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  programs.fish.enable = true;

  # Enable nix-ld to run dynamically linked executables (needed for Claude Code and other binaries)
  programs.nix-ld.enable = true;
}

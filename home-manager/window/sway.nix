# Sway window manager configuration
{ config, pkgs, lib, ... }:

{
  # Sway is disabled by default - enable it in your host-specific config if needed
  # To use Sway instead of Plasma, set:
  #   wayland.windowManager.sway.enable = true;
  #   programs.plasma.enable = lib.mkForce false;

  wayland.windowManager.sway = {
    enable = lib.mkDefault false;
    
    # Use the system's Sway package with wrapGTK for proper GTK integration
    package = pkgs.sway;
    
    # Enable swaynag for warning/error messages
    swaynag.enable = true;
    
    # Enable XWayland for X11 app compatibility
    xwayland = true;
    
    # Extra packages to install with Sway
    extraPackages = with pkgs; [
      swaylock        # Screen locker
      swayidle        # Idle management daemon
      wl-clipboard    # Wayland clipboard utilities
      mako            # Notification daemon
      wofi            # Application launcher (rofi alternative for Wayland)
      grim            # Screenshot utility
      slurp           # Screen area selection
      waybar          # Status bar
      brightnessctl   # Brightness control
      pamixer         # PulseAudio mixer CLI
    ];
    
    config = rec {
      # Use alacritty as the default terminal
      terminal = "alacritty";
      
      # Use wofi as the application launcher
      menu = "wofi --show drun";
      
      # Use Super (Windows) key as the modifier
      modifier = "Mod4";
      
      # Default font
      fonts = {
        names = [ "JetBrains Mono" ];
        size = 10.0;
      };
      
      # Window gaps
      gaps = {
        inner = 8;
        outer = 4;
      };
      
      # Window borders
      window = {
        border = 2;
        titlebar = false;
        commands = [
          # Float certain windows by default
          { criteria = { app_id = "pavucontrol"; }; command = "floating enable"; }
          { criteria = { app_id = "blueman-manager"; }; command = "floating enable"; }
          { criteria = { title = "Picture-in-Picture"; }; command = "floating enable"; }
        ];
      };
      
      # Floating window settings
      floating = {
        border = 2;
        titlebar = false;
        criteria = [
          { title = "Steam - Update News"; }
          { class = "Pavucontrol"; }
        ];
      };
      
      # Input configuration
      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_variant = "intl";
          xkb_options = "caps:escape"; # Use Caps Lock as Escape
        };
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "enabled"; # Disable while typing
        };
      };
      
      # Output (display) configuration - customize per host if needed
      output = {
        "*" = {
          bg = "#1e1e1e solid_color";
        };
      };
      
      # Keybindings
      keybindings = let
        mod = modifier;
      in lib.mkOptionDefault {
        # Application launchers
        "${mod}+Return" = "exec ${terminal}";
        "${mod}+d" = "exec ${menu}";
        "${mod}+Shift+q" = "kill";
        
        # Reload and exit
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'Exit Sway?' -B 'Yes' 'swaymsg exit'";
        
        # Lock screen
        "${mod}+l" = "exec swaylock -f -c 1e1e1e";
        
        # Focus movement (vim-like)
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        # Note: ${mod}+l is used for lock, use arrows for right focus
        "${mod}+Right" = "focus right";
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        
        # Window movement
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";
        
        # Splitting
        "${mod}+b" = "splith";
        "${mod}+v" = "splitv";
        
        # Layout
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";
        "${mod}+a" = "focus parent";
        
        # Scratchpad
        "${mod}+Shift+minus" = "move scratchpad";
        "${mod}+minus" = "scratchpad show";
        
        # Screenshots
        "${mod}+Print" = "exec grim - | wl-copy"; # Full screen to clipboard
        "${mod}+Shift+Print" = "exec grim -g \"$(slurp)\" - | wl-copy"; # Selection to clipboard
        "${mod}+Alt+Print" = "exec grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"; # Save to file
        
        # Media keys
        "XF86AudioRaiseVolume" = "exec pamixer -i 5";
        "XF86AudioLowerVolume" = "exec pamixer -d 5";
        "XF86AudioMute" = "exec pamixer -t";
        "XF86AudioMicMute" = "exec pamixer --default-source -t";
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
      };
      
      # Workspace configuration
      workspaceOutputAssign = [ ];
      
      # Startup applications
      startup = [
        # Set GTK theme
        { command = "gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'"; }
        # Start notification daemon
        { command = "mako"; }
        # Idle management
        { 
          command = ''
            swayidle -w \
              timeout 300 'swaylock -f -c 1e1e1e' \
              timeout 600 'swaymsg "output * dpms off"' \
              resume 'swaymsg "output * dpms on"' \
              before-sleep 'swaylock -f -c 1e1e1e'
          ''; 
        }
      ];
      
      # Status bar configuration
      bars = [
        {
          position = "top";
          command = "waybar";
          # Fallback to swaybar if waybar isn't configured
          # command = "${pkgs.sway}/bin/swaybar";
        }
      ];
      
      # Color scheme (dark theme matching alacritty)
      colors = {
        focused = {
          border = "#78dce8";
          background = "#1e1e1e";
          text = "#d4d4d4";
          indicator = "#a9dc76";
          childBorder = "#78dce8";
        };
        focusedInactive = {
          border = "#5b5b5b";
          background = "#1e1e1e";
          text = "#d4d4d4";
          indicator = "#5b5b5b";
          childBorder = "#5b5b5b";
        };
        unfocused = {
          border = "#1e1e1e";
          background = "#1e1e1e";
          text = "#5b5b5b";
          indicator = "#1e1e1e";
          childBorder = "#1e1e1e";
        };
        urgent = {
          border = "#f48771";
          background = "#f48771";
          text = "#1e1e1e";
          indicator = "#f48771";
          childBorder = "#f48771";
        };
      };
    };
    
    # Extra configuration lines
    extraConfig = ''
      # Hide cursor after 5 seconds of inactivity
      seat * hide_cursor 5000
    '';
  };

  # Waybar configuration
  programs.waybar = {
    enable = lib.mkDefault false;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "pulseaudio" "network" "battery" "clock" "tray" ];
        
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
        
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };
        
        "sway/window" = {
          max-length = 50;
        };
        
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰂄 {capacity}%";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };
        
        network = {
          format-wifi = "󰖩 {signalStrength}%";
          format-ethernet = "󰈀 {ifname}";
          format-disconnected = "󰖪 ";
          tooltip-format = "{ifname}: {ipaddr}";
        };
        
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 ";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pavucontrol";
        };
        
        tray = {
          spacing = 10;
        };
      };
    };
    
    style = ''
      * {
        font-family: "JetBrains Mono";
        font-size: 13px;
      }

      window#waybar {
        background-color: rgba(30, 30, 30, 0.9);
        color: #d4d4d4;
        border-bottom: 2px solid #78dce8;
      }

      #workspaces button {
        padding: 0 8px;
        color: #d4d4d4;
        background-color: transparent;
        border-bottom: 2px solid transparent;
      }

      #workspaces button:hover {
        background: rgba(120, 220, 232, 0.2);
      }

      #workspaces button.focused {
        border-bottom: 2px solid #78dce8;
        color: #78dce8;
      }

      #workspaces button.urgent {
        background-color: #f48771;
        color: #1e1e1e;
      }

      #clock,
      #battery,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 10px;
      }

      #battery.warning {
        color: #ffd866;
      }

      #battery.critical {
        color: #f48771;
      }

      #network.disconnected {
        color: #f48771;
      }
    '';
  };
}

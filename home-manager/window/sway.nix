# Sway window manager configuration
{ config, pkgs, lib, ... }:

{
  # Sway is disabled by default - enable it in your host-specific config if needed
  # To use Sway instead of Plasma, set:
  #   wayland.windowManager.sway.enable = true;
  #   programs.plasma.enable = lib.mkForce false;

  # Sway-related packages (only installed when sway is enabled)
  home.packages = lib.mkIf config.wayland.windowManager.sway.enable (with pkgs; [
    swaylock        # Screen locker
    swayidle        # Idle management daemon
    wl-clipboard    # Wayland clipboard utilities
    mako            # Notification daemon
    wofi            # Application launcher
    grim            # Screenshot utility
    slurp           # Screen area selection
    brightnessctl   # Brightness control
    pamixer         # PulseAudio mixer CLI
    swayr           # Window switcher and more
    gammastep       # Night light / blue light filter (CLI + indicator)
    imv             # Image viewer for screen freeze during screenshots
    bemoji          # Emoji picker for Wayland
    wtype           # Wayland keyboard input tool (for typing selected emoji)
    jq
  ]);

  # Gammastep (night light) service configuration
  services.gammastep = lib.mkIf config.wayland.windowManager.sway.enable {
    enable = true;
    tray = true;  # Enable system tray indicator for GUI control
    
    # Location for automatic sunrise/sunset (set your coordinates)
    # You can find your coordinates at: https://www.latlong.net/
    provider = "manual";
    latitude = -23.5505;  # São Paulo City
    longitude = -46.6333;
    
    # Temperature settings (in Kelvin)
    # Lower values = warmer/more orange, Higher values = cooler/more blue
    temperature = {
      day = 6500;    # Neutral daylight
      night = 3500;  # Warm night light
    };
    
    # Brightness settings (0.1 to 1.0)
    settings = {
      general = {
        brightness-day = 1.0;
        brightness-night = 0.8;
        fade = 1;  # Smooth transition between day/night
        adjustment-method = "wayland";
      };
    };
  };

  wayland.windowManager.sway = {
    # Use the system's Sway package with wrapGTK for proper GTK integration
    package = pkgs.sway;
    
    # Enable swaynag for warning/error messages
    swaynag.enable = true;
    
    # Enable XWayland for X11 app compatibility
    xwayland = true;
    
    config = rec {
      # Use alacritty as the default terminal
      terminal = "alacritty";
      
      # Use wofi as the application launcher
      menu = "wofi --show drun";
      
      # Use Super (Windows) key as the modifier
      modifier = "Mod4";
      
      # Disable focus follows mouse
      focus.followMouse = false;
      
      # Default font
      fonts = {
        names = [ "JetBrains Mono" ];
        size = 10.0;
      };
      
      # Window gaps - reduced for tighter layout
      gaps = {
        inner = 2;
        outer = 0;
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
          # Float gammastep indicator if it opens a window
          { criteria = { app_id = "gammastep-indicator"; }; command = "floating enable"; }
          # Float imv for screenshot freeze (fullscreen mode)
          { criteria = { app_id = "imv"; }; command = "fullscreen enable"; }
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
          pointer_accel = "0.4"; # Increase sensitivity (-1 to 1)
          accel_profile = "adaptive"; # or "flat" for linear response
        };
      };
      
      # Output (display) configuration - customize per host if needed
      output = {
        "*" = {
          bg = "#f5f0ff solid_color";
        };
        # HDMI monitor on the left at 165Hz
        "HDMI-A-1" = {
          position = "0 0";
          mode = "1920x1080@165Hz";  # Adjust resolution if needed
        };
        # Laptop display on the right
        "eDP-1" = {
          position = "1920 0";  # Adjust X position based on HDMI resolution
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
        
        # Emoji picker (Mod+period like macOS/Windows)
        "${mod}+period" = "exec bemoji -t";
        
        # Reload and exit
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'Exit Sway?' -B 'Yes' 'swaymsg exit'";
        
        # Lock screen
        "${mod}+l" = "exec swaylock -f -c f5f0ff";
        
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
        
        "Control+${mod}+Left" = "workspace prev";
        "Control+${mod}+Right" = "workspace next";
        # Scratchpad
        "${mod}+Shift+minus" = "move scratchpad";
        "${mod}+minus" = "scratchpad show";
        
        # Screenshots (with screen freeze for area selection - active monitor only)
        # Selection to clipboard - freezes screen during selection
        "Print" = ''exec bash -c 'output=$(swaymsg -t get_outputs | jq -r ".[] | select(.focused) | .name") && tmp=$(mktemp /tmp/screenshot-XXXXXX.png) && grim -o "$output" "$tmp" && imv-wayland -f "$tmp" & sleep 0.2 && grim -g "$(slurp)" - | wl-copy; pkill imv-wayland; rm -f "$tmp"' '';
        # Full screen to clipboard (active monitor only)
        "${mod}+Print" = ''exec bash -c 'grim -o "$(swaymsg -t get_outputs | jq -r ".[] | select(.focused) | .name")" - | wl-copy' '';
        # Selection to file - freezes screen during selection
        "${mod}+Shift+Print" = ''exec bash -c 'output=$(swaymsg -t get_outputs | jq -r ".[] | select(.focused) | .name") && tmp=$(mktemp /tmp/screenshot-XXXXXX.png) && grim -o "$output" "$tmp" && imv-wayland -f "$tmp" & sleep 0.2 && grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png; pkill imv-wayland; rm -f "$tmp"' '';
        
        # Media keys
        "XF86AudioRaiseVolume" = "exec pamixer -i 5";
        "XF86AudioLowerVolume" = "exec pamixer -d 5";
        "XF86AudioMute" = "exec pamixer -t";
        "XF86AudioMicMute" = "exec pamixer --default-source -t";
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";

        # Night light toggle (quick toggle via keybind)
        "${mod}+n" = "exec pkill -USR1 gammastep";  # Toggle on/off

        # Alt+Tab window switching with swayr
        "Mod1+Tab" = "exec swayr switch-window";
        "Mod1+Shift+Tab" = "exec swayr switch-window";
        
                # Multi-monitor synchronized workspace switching
        # When you press Mod+1, it switches to workspace 1 on main monitor AND workspace 6 on second monitor
        "${mod}+1" = "workspace number 1; workspace number 6";
        "${mod}+2" = "workspace number 2; workspace number 7";
        "${mod}+3" = "workspace number 3; workspace number 8";
        "${mod}+4" = "workspace number 4; workspace number 9";
        "${mod}+5" = "workspace number 5; workspace number 10";
        
        # Move windows to synchronized workspaces
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        
        # Individual workspace access for second monitor (if needed)
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";
        
        # Move windows to individual workspaces on second monitor
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";
      };
      
      # Workspace configuration - Multi-monitor setup
      # IMPORTANT: Find your actual monitor names with: swaymsg -t get_outputs
      # Common examples: "eDP-1" (laptop), "HDMI-A-1", "DP-1", "DP-2", etc.
      # Replace the output names below with your actual monitor names
      workspaceOutputAssign = [
        # Main monitor workspaces (1-5)
        { workspace = "1"; output = "eDP-1"; }  # Change "eDP-1" to your main monitor
        { workspace = "2"; output = "eDP-1"; }
        { workspace = "3"; output = "eDP-1"; }
        { workspace = "4"; output = "eDP-1"; }
        { workspace = "5"; output = "eDP-1"; }
        # Secondary monitor workspaces (6-10)
        { workspace = "6"; output = "HDMI-A-1"; }  # Change "HDMI-A-1" to your second monitor
        { workspace = "7"; output = "HDMI-A-1"; }
        { workspace = "8"; output = "HDMI-A-1"; }
        { workspace = "9"; output = "HDMI-A-1"; }
        { workspace = "10"; output = "HDMI-A-1"; }
      ];
      
      # Startup applications
      startup = [
        # Set GTK theme
        { command = "gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'"; }
        # Start notification daemon
        { command = "mako"; }
        # Start swayr daemon
        { command = "env RUST_BACKTRACE=1 RUST_LOG=swayr=debug swayrd"; }
        # Idle management
        { 
          command = ''
            swayidle -w \
              timeout 300 'swaylock -f -c f5f0ff' \
              timeout 600 'swaymsg "output * dpms off"' \
              resume 'swaymsg "output * dpms on"' \
              before-sleep 'swaylock -f -c f5f0ff'
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
      
      # Color scheme (purple/violet light theme)
      colors = {
        focused = {
          border = "#9333ea";
          background = "#f5f0ff";
          text = "#4a3a5c";
          indicator = "#a855f7";
          childBorder = "#9333ea";
        };
        focusedInactive = {
          border = "#c4b5fd";
          background = "#faf4ff";
          text = "#6b5b7a";
          indicator = "#c4b5fd";
          childBorder = "#c4b5fd";
        };
        unfocused = {
          border = "#e9e0f5";
          background = "#faf4ff";
          text = "#8b7a9c";
          indicator = "#e9e0f5";
          childBorder = "#e9e0f5";
        };
        urgent = {
          border = "#dc2626";
          background = "#fef2f2";
          text = "#991b1b";
          indicator = "#dc2626";
          childBorder = "#dc2626";
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
        modules-right = [ "custom/gammastep" "pulseaudio" "network" "battery" "clock" "tray" ];
        
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
        
        # Night light indicator for waybar
        "custom/gammastep" = {
          format = "{icon}";
          format-icons = {
            on = "󰌵";    # Sun icon when active
            off = "󰌶";   # Moon icon when inactive
          };
          exec = "if pgrep -x gammastep > /dev/null; then echo '{\"class\": \"on\", \"alt\": \"on\", \"tooltip\": \"Night light: ON\"}'; else echo '{\"class\": \"off\", \"alt\": \"off\", \"tooltip\": \"Night light: OFF\"}'; fi";
          return-type = "json";
          interval = 5;
          on-click = "pkill -USR1 gammastep";  # Toggle night light
          tooltip = true;
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
    
    # Purple/Violet Light Theme for Waybar
    style = ''
      * {
        font-family: "JetBrains Mono";
        font-size: 13px;
      }

      window#waybar {
        background-color: rgba(250, 244, 255, 0.95);
        color: #4a3a5c;
        border-bottom: 2px solid #9333ea;
      }

      #workspaces button {
        padding: 0 8px;
        color: #6b5b7a;
        background-color: transparent;
        border-bottom: 2px solid transparent;
      }

      #workspaces button:hover {
        background: rgba(147, 51, 234, 0.15);
      }

      #workspaces button.focused {
        border-bottom: 2px solid #9333ea;
        color: #9333ea;
        background: rgba(147, 51, 234, 0.1);
      }

      #workspaces button.urgent {
        background-color: #dc2626;
        color: #ffffff;
      }

      #clock,
      #battery,
      #network,
      #pulseaudio,
      #custom-gammastep,
      #tray {
        padding: 0 10px;
        color: #4a3a5c;
      }

      #custom-gammastep.on {
        color: #ca8a04;
      }

      #custom-gammastep.off {
        color: #9ca3af;
      }

      #battery.warning {
        color: #ca8a04;
      }

      #battery.critical {
        color: #dc2626;
      }

      #network.disconnected {
        color: #dc2626;
      }

      tooltip {
        background-color: #faf4ff;
        border: 1px solid #c4b5fd;
        border-radius: 4px;
      }

      tooltip label {
        color: #4a3a5c;
      }
    '';
  };
}

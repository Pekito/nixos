# Alacritty terminal configuration
{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    
    settings = {
      window = {
        padding = {
          x = 10;
          y = 10;
        };
        decorations = "full";
        opacity = 0.98;
      };

      font = {
        normal = {
          family = "JetBrains Mono";
          style = "Regular";
        };
        bold = {
          family = "JetBrains Mono";
          style = "Bold";
        };
        italic = {
          family = "JetBrains Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrains Mono";
          style = "Bold Italic";
        };
        size = 11.0;
      };

      # Purple/Violet Light Theme
      colors = {
        primary = {
          background = "#faf4ff";
          foreground = "#4a3a5c";
        };
        cursor = {
          text = "#faf4ff";
          cursor = "#7c3aed";
        };
        normal = {
          black = "#4a3a5c";
          red = "#dc2626";
          green = "#16a34a";
          yellow = "#ca8a04";
          blue = "#6366f1";
          magenta = "#9333ea";
          cyan = "#0891b2";
          white = "#f5f5f5";
        };
        bright = {
          black = "#6b5b7a";
          red = "#ef4444";
          green = "#22c55e";
          yellow = "#eab308";
          blue = "#818cf8";
          magenta = "#a855f7";
          cyan = "#06b6d4";
          white = "#ffffff";
        };
      };

      scrolling = {
        history = 10000;
      };
    };
  };
}

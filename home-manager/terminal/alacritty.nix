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
        opacity = 0.95;
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

      colors = {
        primary = {
          background = "#1e1e1e";
          foreground = "#d4d4d4";
        };
        cursor = {
          text = "#1e1e1e";
          cursor = "#d4d4d4";
        };
        normal = {
          black = "#1e1e1e";
          red = "#f48771";
          green = "#a9dc76";
          yellow = "#ffd866";
          blue = "#78dce8";
          magenta = "#ab9df2";
          cyan = "#78dce8";
          white = "#d4d4d4";
        };
        bright = {
          black = "#5b5b5b";
          red = "#f48771";
          green = "#a9dc76";
          yellow = "#ffd866";
          blue = "#78dce8";
          magenta = "#ab9df2";
          cyan = "#78dce8";
          white = "#ffffff";
        };
      };

      scrolling = {
        history = 10000;
      };
    };
  };
}

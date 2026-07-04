{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      # --- 基础窗口配置 ---
      window = {
        decorations = "None";
        dynamic_title = true;
        opacity = 0.82;
        startup_mode = "Windowed";
      };

      # --- 字体配置 ---
      font = {
        size = 12.0;
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
      };

      # --- 滚动与终端行为 ---
      scrolling = {
        history = 10000;
      };

      terminal = {
        osc52 = "CopyPaste";
      };

      # --- 颜色配置 (已整合 dank-theme.toml) ---
      colors = {
        primary = {
          background = "#111418"; # 使用了 Dank Theme 的背景色
          foreground = "#e1e2e8";
        };

        selection = {
          text = "#e1e2e8";
          background = "#1a4975";
        };

        cursor = {
          text = "#111418";
          cursor = "#a0cafd";
        };

        normal = {
          black   = "#111418";
          red     = "#ff729c";
          green   = "#7efd8f";
          yellow  = "#fff772";
          blue    = "#86b6f0";
          magenta = "#264975";
          cyan    = "#a0cafd";
          white   = "#eff6ff";
        };

        bright = {
          black   = "#989da4";
          red     = "#ff9fbb";
          green   = "#a5ffb1";
          yellow  = "#fffaa5";
          blue    = "#afd3ff";
          magenta = "#bddbff";
          cyan    = "#d4e7ff";
          white   = "#f8fbff";
        };
      };
    };
  };
}
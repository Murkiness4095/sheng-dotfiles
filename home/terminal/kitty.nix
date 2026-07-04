{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    # --- 字体配置 ---
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    # --- 快捷键映射 ---
    keybindings = {
      "ctrl+shift+m" = "toggle_maximized";
      "ctrl+shift+f" = "show_scrollback";
    };

    # --- 核心设置 ---
    settings = {
      # 窗口装饰与基础行为
      hide_window_decorations = "titlebar-and-corners";
      background_opacity = "0.82"; 
      enable_audio_bell = "no";
      confirm_os_window_close = 0;

      # 标签栏 (Tab Bar) 样式
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_bar_align = "left";
      tab_bar_min_tabs = 2;
      tab_bar_margin_width = "0.0";
      tab_bar_margin_height = "2.5 1.5";
      tab_bar_margin_color = "#111418";
      tab_bar_background = "#111418";

      # 标签状态颜色
      active_tab_foreground = "#003258";
      active_tab_background = "#a0cafd";
      active_tab_font_style = "bold";
      inactive_tab_foreground = "#c3c6cf";
      inactive_tab_background = "#111418";
      inactive_tab_font_style = "normal";

      # 标签标题模板
      tab_activity_symbol = " ● ";
      tab_title_template = "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title[:30]}{title[30:] and '…'} [{index}]";
      active_tab_title_template = "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title[:30]}{title[30:] and '…'} [{index}]";

      # --- 颜色方案 (Dank Theme) ---
      cursor = "#e1e2e8";
      cursor_text_color = "#c3c6cf";
      foreground = "#e1e2e8";
      background = "#111418";
      selection_foreground = "#253140";
      selection_background = "#bbc7db";
      url_color = "#a0cafd";

      # 基础 16 色
      # Normal
      color0 = "#111418"; # black
      color1 = "#ff729c"; # red
      color2 = "#7efd8f"; # green
      color3 = "#fff772"; # yellow
      color4 = "#86b6f0"; # blue
      color5 = "#264975"; # magenta
      color6 = "#a0cafd"; # cyan
      color7 = "#eff6ff"; # white

      # Bright
      color8 = "#989da4";
      color9 = "#ff9fbb";
      color10 = "#a5ffb1";
      color11 = "#fffaa5";
      color12 = "#afd3ff";
      color13 = "#bddbff";
      color14 = "#d4e7ff";
      color15 = "#f8fbff";
    };
  };
}
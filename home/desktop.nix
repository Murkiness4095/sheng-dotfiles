{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- 以下已被 DankMaterialShell 完美替代，选择注释 ---
    # swaybg
    # waypaper
    # hyprlock
    # swaylock-effects
    # swayidle
    # wlogout
    # wlsunset
    # waybar

    # --- 以下为核心底层工具与基础应用，保持保留 ---
    fuzzel
    uwsm                 
    xwayland-satellite
    file-roller
    loupe
    papers
    adwaita-icon-theme
    gnome-themes-extra
  ];

  # 调整亮度音量显示（DMS 已内置音量亮度 OSD 弹窗）
  # services.avizo.enable = true;

  # 通知显示（DMS 已内置独立的通知中心）
  # services.swaync.enable = true;

  # 根据不同的设备加载不同的显示器分辨率刷新率缩放
  # 就不用去 wm 里面一个一个配，导致每次换设备都要修改配置
  # https://wiki.archlinux.org/title/Kanshi
  # services.kanshi.enable = true;

  # 夜光护眼软件（DMS 控制中心已原生集成 Night Mode）
  # services.wlsunset = {
  #   enable = true;
  #   sunset = "19:00";
  #   sunrise = "07:00";
  # };

  # 壁纸软件（DMS 自带壁纸管理，且需要借此通过 Matugen 自动生成动态主题色）
  # services.wpaperd = {
  #   enable = true;
  #   settings = {
  #     default = {
  #       duration = "30m";
  #       mode = "center";
  #     };
  #     any.path = "${config.home.homeDirectory}/Pictures/Wallpapers";
  #   };
  # };

  xdg.configFile."niri".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/sheng-dotfiles/dotfiles/niri";
}
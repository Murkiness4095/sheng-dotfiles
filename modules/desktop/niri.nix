{ config, lib, pkgs, ... }:

{
  programs.niri.enable = true;

  programs.dms-shell.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --time --time-format '%Y-%m-%d %H:%M' --asterisks --remember --remember-session";
      };
    };
  };

  # 文件管理器
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-volman
      thunar-archive-plugin
    ];
  };

  # 给文件管理器提供预览缩略图的服务
  services.tumbler.enable = true;

  # polkit agent
  security.soteria.enable = true;

  # 磁盘挂载
  services.gvfs.enable = true;
}
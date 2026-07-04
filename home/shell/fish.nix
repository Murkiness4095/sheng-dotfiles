{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "foreign-env";
        src = pkgs.fishPlugins.foreign-env.src;
      }
    ];

    interactiveShellInit = ''
      # 1. 去除欢迎语
      set -g fish_greeting

      # 2. 核心修复：强制将 Guix 的 bin 目录“插队”到 PATH 的最前面！
      # -g 代表全局生效，-p 代表前置 (prepend)
      fish_add_path -g -p ~/.config/guix/current/bin ~/.guix-profile/bin

      # 3. 使用 fenv 加载其他环境变量 (如 MANPATH 手册、C_INCLUDE_PATH 等)
      if test -f "$HOME/.config/guix/current/etc/profile"
        fenv source "$HOME/.config/guix/current/etc/profile"
      end

      if test -f "$HOME/.guix-profile/etc/profile"
        fenv source "$HOME/.guix-profile/etc/profile"
      end
    '';
  };
}
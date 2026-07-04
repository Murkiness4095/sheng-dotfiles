{ config, pkgs, lib, ... }:

{
  home.file.".p10k.zsh" = {
    source = ./p10k.zsh;
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.home.homeDirectory}/.config/zsh";

    # 基础功能
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # 历史记录
    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
      share = true;
    };

    # 常用别名
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
      gs = "git status";
    };

    # 插件管理方式 1：zplug（推荐）
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
      ];
    };
    
    envExtra = ''
      export GUIX_PROFILE="${config.home.homeDirectory}/.config/guix/current"
      if [ -f "$GUIX_PROFILE/etc/profile" ]; then
        . "$GUIX_PROFILE/etc/profile"
      fi
      
      export GUIX_USER_PROFILE="${config.home.homeDirectory}/.guix-profile"
      if [ -f "$GUIX_USER_PROFILE/etc/profile" ]; then
        . "$GUIX_USER_PROFILE/etc/profile"
      fi
    '';
  };
}

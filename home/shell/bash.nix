{ config, pkgs, ... }:

let
  # ==========================================================
  # [开关] 设置你想要通过 Bash 自动拉起的 Shell: "fish", "zsh" 或 "bash"
  # ==========================================================
  currentShell = "fish"; 
in
{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    # 根据 currentShell 变量动态生成 Bash 的交互式启动脚本
    initExtra = 
      if currentShell == "fish" then ''
        if [[ $(${pkgs.procps}/bin/ps -p $PPID -o comm=) != "fish" && -z "$BASH_EXECUTION_STRING" ]]; then
          if [[ $- == *i* ]]; then
            exec ${pkgs.fish}/bin/fish
          fi
        fi
      ''
      else if currentShell == "zsh" then ''
        if [[ $(${pkgs.procps}/bin/ps -p $PPID -o comm=) != "zsh" && -z "$BASH_EXECUTION_STRING" ]]; then
          if [[ $- == *i* ]]; then
            exec ${pkgs.zsh}/bin/zsh
          fi
        fi
      ''
      else ""; # 如果是 "bash" 或其他，不执行套娃替换

    # Guix 环境变量注入
    profileExtra = ''
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
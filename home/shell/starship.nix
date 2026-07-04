{ config, lib, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true; 

    # settings = builtins.fromTOML (builtins.readFile ../.../starship.toml);
    settings = {
      # 对应 TOML 中的 format 字段
      # 使用 lib.concatStrings 拼接，保持整洁
      format = lib.concatStrings [
        "[░▒▓](#a3aed2)"
        "[  ](bg:#a3aed2 fg:#090c0c)"
        "$hostname"
        "[](bg:#769ff0 fg:#a3aed2)"
        "$directory"
        "[](fg:#769ff0 bg:#394260)"
        "$git_branch"
        "$git_status"
        "[](fg:#394260 bg:#212736)"
        "$nodejs"
        "$rust"
        "$golang"
        "$php"
        "$nix_shell"
        "[](fg:#212736 bg:#1d2230)"
        "$time"
        "[ ](fg:#1d2230)"
        "\n$character"
      ];

      # [hostname]
      hostname = {
        ssh_only = true;
        format = "[ $hostname ](bg:#a3aed2 fg:#090c0c)";
        trim_at = ".";
        disabled = false;
      };

      # [directory]
      directory = {
        style = "fg:#e3e5e5 bg:#769ff0";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";

        # [directory.substitutions]
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      # [git_branch]
      git_branch = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
      };

      # [git_status]
      git_status = {
        style = "bg:#394260";
        format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
      };

      # [nodejs]
      nodejs = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      # [rust]
      rust = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      # [golang]
      golang = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      # [php]
      php = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      # [time]
      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:#1d2230";
        format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
      };

      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol$state( \($name\))]($style) ";
        style = "bold blue";
      };
    };
  };
}
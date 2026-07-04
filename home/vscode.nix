{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-ceintl.vscode-language-pack-zh-hans
      eamodio.gitlens      # GitLens: 查看代码作者、历史、Blame信息
      mhutchie.git-graph   # Git Graph: 可视化的 Git 分支提交图表
      jnoortheen.nix-ide
      continue.continue
    ];

    profiles.default.userSettings = {
      "locale" = "zh-CN";
      "editor.fontSize" = 14; # 控制代码字体大小
      "editor.tabSize" = 2; # 控制缩进宽度
      "files.autoSave" = "onFocusChange"; # 自动保存

      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.formatterPath" = "nixpkgs-fmt";
    };
  };
}

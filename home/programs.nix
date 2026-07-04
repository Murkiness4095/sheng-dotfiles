{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    fastfetch
    tree
    localsend

    # 剪贴板
    wl-clipboard
    cliphist
    copyq

    # 截图
    grim 
    slurp
    satty   # 截图编辑标注

    bazaar  # flatpak的图形化管理工具

    # gjs-osk
    # gnome-console
    nautilus
    curl
    evtest
    gitMinimal
    brightnessctl
    iproute2
    iw
    nano
    pciutils
    usbutils
    vim
    wget

    nil
    nixpkgs-fmt

    # Vibe Coding
    antigravity-cli
    antigravity-fhs
    ollama
    mcp-nixos
  ];
}
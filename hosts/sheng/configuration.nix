# ---
# Module: Personal Sheng Host
# Description: Defines the private user and system preferences layered over the sheng platform
# Scope: System
# ---

{ pkgs, ... }:

{
  imports = [
    ../../modules
  ];

  networking.hostName = "nixos-sheng";
  
  # 开启 upower 服务，让它去自动枚举高通的电池并提交给 DBus
  services.upower.enable = true;
}

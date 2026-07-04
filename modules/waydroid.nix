{ config, lib, pkgs, ... }:

{
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid;
  };

  environment.variables = {
    WAYDROID_NET_BACKEND = "iptables";
  };

  environment.systemPackages = with pkgs; [
    waydroid-helper
    cage
  ];
}

# networking.nix
{ ... }:
{
  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # 2023   # daed WebUI
      # 2536
      # 12345  # daed/dae
      # 6099   # napcat
      # 6181   # astrbot
      # 6182
      53317
    ];
    allowedUDPPorts = [
      # 69     # tftp
      # 12345
      53317
    ];
    checkReversePath = false;
    trustedInterfaces = [ "wlan0"];
  };

  networking.nftables.enable = false;
}
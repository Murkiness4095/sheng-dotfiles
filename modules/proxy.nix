{ ... }:

{
  services.daed = {
    enable = false;
    openFirewall = {
      enable = true;
      port = 12345;
    };
    configDir = "/etc/daed";
    listen = "0.0.0.0:2023";
  };
}
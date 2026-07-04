{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
    profiles.default = {
      isDefault = true;
      id = 0;
      # extensions.packages = with pkgs.firefox-addons; [ 
      #   sidebery
      #   ublock-origin
      # ];
      settings = {
        "intl.locale.requested" = "zh-CN";
        "layout.css.prefers-color-scheme.content-override" = 0;
        "browser.tabs.allowTabDetach" = false;  # 禁止将标签页拖拽为新窗口
        "network.http.max-persistent-connections-per-server" = 20;
        "dom.fetch.keepalive.enabled" = true;
      };
    };
  };
}
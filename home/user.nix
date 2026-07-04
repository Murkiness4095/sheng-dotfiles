# ---
# Module: Personal User Home
# Description: Provides an example Home Manager profile for the private sheng user
# Scope: Home Manager
# ---

{ ... }:

{
  home.username = "fall_dust";
  home.homeDirectory = "/home/fall_dust";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
  programs.bash.enable = true;
}

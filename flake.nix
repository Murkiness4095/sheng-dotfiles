{
  description = "Personal configuration for a Xiaomi Pad 6S Pro running Mobile NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-sheng.url = "github:DotRedstone/nixos-sheng?dir=nixos";

    daeuniverse.url = "github:daeuniverse/flake.nix";

    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
  };

  outputs = { nixpkgs, home-manager, nixos-sheng, ... }@inputs:
    let
      system = "aarch64-linux";
    in
    {
      nixosConfigurations.sheng = 
        nixos-sheng.lib.${system}.mkShengSystem [
          { _module.args.inputs = inputs; }
            ./hosts/sheng/configuration.nix
            inputs.daeuniverse.nixosModules.daed

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.fall_dust = ./home;
            }
        ];
    };
}

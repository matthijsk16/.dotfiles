{

  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      mkSystem = packages: system: hostname:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { 
            inherit inputs; 
            pkgs = import packages { 
              inherit system; 
              config = { allowUnfree = true; }; 
            };
          };
          modules = [
            { networking.hostName = hostname; }
            ./modules/system/configuration.nix
            ./hosts/${hostname}/configuration.nix
          ];
        };

    in {
    nixosConfigurations = {
      PC-Matthijs = mkSystem nixpkgs "x86_64-linux" "PC-Matthijs";
      Laptop-Matthijs = mkSystem nixpkgs "x86_64-linux" "Laptop-Matthijs";
    };
  };

}

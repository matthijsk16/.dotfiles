{

  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    oldnixpkgs.url = "nixpkgs/nixos-20.09";

    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      username = "matthijs";

      mkSystem = packages: system: hostname:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { 
            inherit inputs username; 
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
      NIXVM = mkSystem nixpkgs "x86_64-linux" "NIXVM";
    };
  };

}

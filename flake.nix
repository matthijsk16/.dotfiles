{

  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      username = "matthijs";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
    nixosConfigurations = {
      NIXVM = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs username system; };
        modules = [ 
          ./hosts/default/configuration.nix
          ./hosts/NIXVM/configuration.nix 
          ];
      };
    };
  };

}

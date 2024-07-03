{

  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };
# hoi
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
      VM = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs username system; };
        modules = [ ./hosts/VM/configuration.nix ];
      };
    };

    homeConfigurations = {
      ${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs username; };
        modules = [ ./home-manager/home.nix ];
      };
    };
  };

}

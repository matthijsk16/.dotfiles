{

  description = "First flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      VM = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/VM/configuration.nix ];
      };
    };
  };

}

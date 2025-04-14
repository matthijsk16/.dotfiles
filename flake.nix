{

  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grub2-themes.url = "github:vinceliuice/grub2-themes";

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # https://github.com/winapps-org/winapps
    # https://github.com/winapps-org/winapps/pull/234/files/e8dc55a83abd3eb6b275990fb19bdb589b6ce13d#diff-b335630551682c19a781afebcf4d07bf978fb1f8ac04c6bf87428ed5106870f5 
    # https://nowsci.com/winapps/ 
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      mkSystem = packages: system: hostname:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { 
            inherit inputs; 
            # pkgs = import packages { 
            #   inherit system; 
            #   config = { allowUnfree = true; }; 
            # };
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

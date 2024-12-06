{ inputs, pkgs, config, ... }:

{
  imports = [ 
    # system
    ./system/configuration.nix
    
    # GUI 
    ./hyprland
    ./sddm

    # GPU
    ./nvidia
    ];
}

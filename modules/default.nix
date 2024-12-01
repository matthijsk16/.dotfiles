{ inputs, pkgs, config, ... }:

{
  imports = [ 
    # system
    ./system/configuration.nix
    
    # Compositor 
    ./hyprland
    ];
}
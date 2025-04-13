{ inputs, pkgs, config, ... }:

{
  imports = [ 
    # system
    ./system/configuration.nix
    
    # GUI 
    ./gnome

    ./plymouth
    ];
}

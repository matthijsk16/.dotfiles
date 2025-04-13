{ inputs, config, pkgs, ... }:

{
  imports =
    [ 
     ./gnome
     ./firefox
      ./vscode
      ./onedrive
    ];
}
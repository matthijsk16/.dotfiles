{ inputs, config, lib, pkgs, ... }:

with lib; let 
  cfg = config.modules.gnome; 

in {
  options.modules.gnome = { 
    enable = mkEnableOption "Enable the GNOME desktop environment";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    services.gnome.core-utilities.enable = false;

    environment.systemPackages = with pkgs; [
      gnome-terminal
      nautilus
      gnomeExtensions.dash-to-dock
    ];
  };
}

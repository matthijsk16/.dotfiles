{ inputs, config, lib, pkgs, ... }:

with lib; let 
  cfg = config.modules.gnome;

in {
  options.modules.gnome = { 
    enable = mkEnableOption "Gnome desktop environment configuration"; 
  };

  config = mkIf cfg.enable {
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface".color-scheme = "prefer-dark";
        "org/gnome/desktop/wm/keybindings" = {
          switch-windows = ["<Alt>Tab"];
          switch-applications = ["<Super>Tab"];
        };
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = with pkgs.gnomeExtensions; [
            dash-to-dock.extensionUuid
          ];
          favorite-apps = [ 
            "org.gnome.Terminal.desktop"
            "firefox.desktop"
            "code.desktop"
          ];
        };
        "org/gnome/shell/extensions/dash-to-dock" = {
          dash-max-icon-size = 64;
          show-trash = false;
        };
      };
    };
  };
}

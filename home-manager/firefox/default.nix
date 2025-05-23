{ inputs, config, lib, pkgs, ... }:

with lib; let 
  cfg = config.modules.firefox; 

  lock-false = {
      Value = false;
      Status = "locked";
    };
    lock-true = {
      Value = true;
      Status = "locked";
    };

in {
  options.modules.firefox = { 
    enable = mkEnableOption "Firefox";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      policies = {
        ExtensionSettings = {
          "*".installation_mode = "blocked"; 
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          };
          # Lean Library:
          "{809ea8a3-a45d-41a2-9cb0-e7c7d7321db5}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/library_access/latest.xpi";
            installation_mode = "force_installed";
          };
          # Zotero Connector:
          "zotero@chnm.gmu.edu" = {
            install_url = "https://www.zotero.org/download/connector/dl?browser=firefox&version=5.0.166";
            installation_mode = "force_installed";
          };
        };
        Preferences = { 
          "general.autoScroll" = lock-true;
        };
      };
    };
  };
}

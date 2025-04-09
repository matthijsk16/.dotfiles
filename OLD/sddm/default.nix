{ inputs, lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.sddm;
in
{
  options.modules.sddm = {
    enable = mkEnableOption "Enable SDDM";
};

  config = mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
    };
  };
}

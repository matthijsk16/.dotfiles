{ inputs, lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.hyprland;
in
{
  options.modules.hyprland = {
    enable = mkEnableOption "Enable hyprland";
};

  config = mkIf cfg.enable {
    modules.nvidia.enable = true;
    modules.sddm.enable = true;

    programs.hyprland.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}

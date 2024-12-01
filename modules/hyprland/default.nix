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
    programs.hyprland.enable = true;
  };
}
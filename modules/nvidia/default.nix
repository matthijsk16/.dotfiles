{ inputs, lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.nvidia;
in
{
  options.modules.nvidia = {
    enable = mkEnableOption "Enable Nvidia";
};

  config = mkIf cfg.enable {
    hardware.graphics.enable = true;

    services.xserver.videoDrivers = ["nvidia"];

    services.xserver.enable = true;

    hardware.nvidia = {
        modesetting.enable = true;

        powerManagement.enable = false;
        powerManagement.finegrained = false;

        open = false;

        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}

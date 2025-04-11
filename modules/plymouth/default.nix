{ inputs, config, lib, pkgs, ... }:

with lib; let 
  cfg = config.modules.plymouth; 

in {
  options.modules.plymouth = { 
    enable = mkEnableOption "Plymouth";
  };

  config = mkIf cfg.enable {
    boot = {

      plymouth = {
        enable = true;
        theme = "rings";
      };

      # Enable "Silent boot"
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];
      # Hide the OS choice for bootloaders.
      # It's still possible to open the bootloader list by pressing any key
      # It will just not appear on screen unless a key is pressed
      loader.timeout = 0;
    };
  };
}

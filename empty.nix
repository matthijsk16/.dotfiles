{ inputs, config, pkgs, ... }:

with lib; let 
  cfg = config.modules.REPLACE; 

in {
  options.modules.REPLACE = { 
    enable = mkEnableOption "REPLACE";

    option1 = mkOption {
      type = types.str;
      default = "kaas";
      description = ''
        This is an example option.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Put config here
  };
}

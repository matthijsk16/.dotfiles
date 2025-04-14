{ inputs, config, lib, pkgs, ... }:

with lib; let 
  cfg = config.modules.winapps; 

in {
  options.modules.winapps = { 
    enable = mkEnableOption "Winapps configuration file";
  };

  config = mkIf cfg.enable {
    home.file."winapps-config-file" = {
      target = ".config/winapps/winapps.conf";
      source = config.lib.file.mkOutOfStoreSymlink config.sops.secrets.winapps.path;      
    };


# PREVENTING AUTO LOGIN
# I figured it out. It has nothing to do with WinApps - the solution is in Windows itself.
#     In the Windows guest, run "netplwiz".
#     Check the box for "Users must enter a user name and password to use this computer".
#     Press Apply, then OK.
#     Log out.
# That should do it.

  };
}

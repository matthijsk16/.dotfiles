{ inputs, config, lib, pkgs, ... }:

with lib; let 
  cfg = config.modules.onedrive; 

in {
  options.modules.onedrive = { 
    enable = mkEnableOption "OneDrive";
  };

  config = mkIf cfg.enable {
    home.file."onedrive_sync_list" = {
      target = ".config/onedrive/sync_list";
      text = ''
        # Include ME_HTE 2 Matthijs Klasens folder 
        /ME_HTE 2 Matthijs Klasens/

        # Include 0 Prive folder
        /0 Prive/Documenten/
      '';
    };
  };
}

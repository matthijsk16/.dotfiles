{ inputs, config, lib, pkgs, ... }:

with lib; let 
  cfg = config.modules.vscode; 

in {
  options.modules.vscode = { 
    enable = mkEnableOption "VSCode";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        github.copilot
        bbenoist.nix
        james-yu.latex-workshop
      ];
      # userSettings = {
      #   "password-store" = "gnome-libsecret";
      # };
    };
  };
}

{ inputs, config, lib, pkgs, ... }:

with lib; let 
  cfg = config.modules.warp; 

in {
  options.modules.warp = { 
    enable = mkEnableOption "Cloudflare WARP client (warp-cli)";
  };

  config = mkIf cfg.enable {
    services.cloudflare-warp.enable = true;
    
    # WARP-CLI 101
    # 1. Enable warp-cli with the config line above
    # 2. Switch to tunnel only mode with: warp-cli mode tunnel_only
    # 3. Go to the following URL to register: https://<teamname>.cloudflareaccess.com/warp
    # 4. Inspect the blue "Open Cloudflare WARP" button and copy the auth token
    # 5. Run the register command with the token: warp-cli registration token https://.cloudflareaccess.com/auth?token=<token>
    # 6. Connect to the tunnel with: warp-cli connect
    # 7. Disable the connectivity check with: warp-cli debug connectivity-check disable
    # References: 
    # https://community.cloudflare.com/t/how-to-register-warp-client-for-linux-via-terminal/653232
    # https://github.com/jamesmcm/vopono/pull/300
  };
}

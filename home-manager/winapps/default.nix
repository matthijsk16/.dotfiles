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

    services.podman.enable = true;
    services.podman.containers."WinApps" = {
      # serviceName = "WinApps";
      image = "ghcr.io/dockur/windows:latest";
      # user = "matthijs";
      # group = "matthijs";

      # https://mynixos.com/home-manager/option/services.podman.containers.%3Cname%3E.network
      # https://docs.podman.io/en/latest/markdown/podman-run.1.html
      # https://github.com/dockur/windows/issues/679
      # network = "user";
      environment = {
        "VERSION" = "11";
        "RAM_SIZE" = "4G";
        "CPU_CORES" = "4";
        "DISK_SIZE" = "64G";
        "USERNAME" = "matthijs";
        "HOME" = "/home/matthijs";
      };
      environmentFile = [ 
        "${config.sops.secrets.windows.path}"
      ];
      ports = [
        "8006:8006"
        "3389:3389/tcp"
        "3389:3389/udp"
      ];
      addCapabilities = [
        "ALL"
        "NET_ADMIN"
        "CAP_NET_RAW"
      ];
      volumes = [
          "/home/matthijs/windows:/storage"
          "/home/matthijs:/shared"
          "/home/matthijs/.dotfiles/modules/winapps/oem:/oem"
        ];
      devices = [
        "/dev/kvm"
        "/dev/net/tun"
      ];
      extraPodmanArgs = [
        "--sysctl net.ipv4.ip_forward=1"
      ];
      autoStart = true;
    };  
  };
}

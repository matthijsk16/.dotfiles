{ inputs, config, lib, pkgs, ... }:

with lib; let 
  cfg = config.modules.winapps; 

in {
  options.modules.winapps = { 
    enable = mkEnableOption "Winapps";
  };

  config = mkIf cfg.enable {
    # environment.systemPackages = [
    #   inputs.winapps.packages."x86_64-linux".winapps
    #   inputs.winapps.packages."x86_64-linux".winapps-launcher
    # ];
    
    virtualisation.oci-containers.backend = "docker";
    virtualisation.oci-containers.containers = {
      # https://github.com/winapps-org/winapps
      "windows" = {
        serviceName = "windows";
        image = "ghcr.io/dockur/windows:latest";
        environment = {
          "VERSION" = "11";
          "RAM_SIZE" = "4G";
          "CPU_CORES" = "4";
          "DISK_SIZE" = "64G";
          "USERNAME" = "matthijs";
          "HOME" = "/home/matthijs";
        };
        environmentFiles = [ 
          "${config.sops.secrets.windows.path}"
        ];
        ports = [
          "8006:8006"
          "3389:3389/tcp"
          "3389:3389/udp"
        ];
        extraOptions = [ "--cap-add=NET_ADMIN" ];
        volumes = [
          "/var/lib/windows:/storage"
          "/home/matthijs:/shared"
          "./oem:/oem"
        ];
        devices = [
          "/dev/kvm"
          "/dev/net/tun"
        ];
        autoStart = false;
      };
    };
  };
}

{ inputs, config, lib, pkgs, ... }:

with lib; let 
  cfg = config.modules.winapps; 

in {
  options.modules.winapps = { 
    enable = mkEnableOption "Winapps";
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [
      "ip_tables"
      "iptable_nat"
    ];

    virtualisation.containers.enable = true;
    virtualisation = {
      podman = {
        enable = true;
        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;
        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };
    
    environment.systemPackages = [
      inputs.winapps.packages."x86_64-linux".winapps
      inputs.winapps.packages."x86_64-linux".winapps-launcher
      pkgs.podman
      pkgs.podman-compose
    ];
    
    virtualisation.oci-containers.backend = "podman";
    virtualisation.oci-containers.containers = {
      # https://github.com/winapps-org/winapps
      "WinApps" = {
        podman.user = "matthijs";
        serviceName = "WinApps";
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
        extraOptions = [ "--cap-add=NET_ADMIN" "--cap-add=CAP_NET_RAW" ];
        volumes = [
          "/var/lib/windows:/storage"
          "/home/matthijs:/shared"
          # "./oem:/oem"
          # Remove after first boot
          "/home/matthijs/.dotfiles/modules/winapps/oem:/oem"
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

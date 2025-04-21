{ inputs, config, lib, pkgs, ... }:

with lib; let 
  cfg = config.modules.winapps; 

in {
  options.modules.winapps = { 
    enable = mkEnableOption "Winapps";
  };

  config = mkIf cfg.enable {
    # boot.kernelModules = [
    #   "ip_tables"
    #   "iptable_nat"
    # ];

    # virtualisation.containers.enable = true;
    # virtualisation = {
    #   podman = {
    #     enable = true;
    #     # Create a `docker` alias for podman, to use it as a drop-in replacement
    #     dockerCompat = true;
    #     # Required for containers under podman-compose to be able to talk to each other.
    #     defaultNetwork.settings.dns_enabled = true;
    #   };
    # };
    
    environment.systemPackages = [
      inputs.winapps.packages."x86_64-linux".winapps
      inputs.winapps.packages."x86_64-linux".winapps-launcher
      # pkgs.podman
      # pkgs.podman-compose
      # pkgs.fuse-overlayfs
      # pkgs.slirp4netns
    ];

    # systemd.sockets."podman.socket".wantedBy = [ "sockets.target" ];

    # # Optional: make the socket accessible to your user
    # systemd.sockets."podman.socket".socketConfig = {
    #   SocketMode = "0660";
    #   SocketGroup = "podman";
    # };

    # # Create the group if not already
    # users.groups.podman = {};
    # users.users.matthijs.extraGroups = [ "podman" ];

    # systemd.services.init-winapps-network = {
    #   description = "Create the network bridge for WinApps.";
    #   after = [ "network.target" ];
    #   wantedBy = [ "multi-user.target" ];
    #   serviceConfig.Type = "oneshot";
    #   script = ''
    #     # Put a true at the end to prevent getting non-zero return code, which will
    #     # crash the whole service.
    #     check=$(${pkgs.podman}/bin/podman network ls | grep "winapps-bridge" || true)
    #     if [ -z "$check" ];
    #       then ${pkgs.podman}/bin/podman network create winapps-bridge
    #       else echo "winapps-bridge already exists in podman"
    #     fi
    #   '';
    # };

    virtualisation.oci-containers.backend = "docker";
    virtualisation.oci-containers.containers = {
      # https://github.com/winapps-org/winapps
      "WinApps" = {
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
        extraOptions = [ 
          "--cap-add=NET_ADMIN"
          "--cap-add=CAP_NET_RAW"
          "--sysctl=net.ipv4.ip_forward=1"
        ];
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

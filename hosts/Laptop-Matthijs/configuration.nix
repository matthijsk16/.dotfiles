{ inputs, config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05h
      inputs.sops-nix.nixosModules.sops
      inputs.grub2-themes.nixosModules.default
      ../../modules/default.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/matthijs/.config/sops/age/keys.txt";

  sops.secrets = {
    windows = {
      sopsFile = ../../secrets/windows.env;
      format = "dotenv";
      owner = "matthijs";
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    users = {
      matthijs = import ./home.nix;
    };
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
    ];
  };

  modules = {
    gnome.enable = true;
    plymouth.enable = true;
    winapps.enable = true;
  };

  # List packages installed in system profile. 
  environment.systemPackages = with pkgs; [
    home-manager # Remove ??
    bat
    git
    gh
    discord
    dconf-editor
    texlive.combined.scheme-full
    lenovo-legion
    signal-desktop
    age
    sops
  ];

  networking.networkmanager.enable = true;

  services.onedrive.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  time.hardwareClockInLocalTime = true;
  nixpkgs.config.allowUnfree = true;

  users.users.matthijs = {
    isNormalUser = true;
    description = "Matthijs Klasens";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
    linger = true;
  };

  boot.loader.grub2-theme = {
    enable = true;
    theme = "vimix";
    footer = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}

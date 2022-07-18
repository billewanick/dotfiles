# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Get me proprietary packages
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.hardwareClockInLocalTime = true;

  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Toronto";

  # Nix daemon config
  nix = {
    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    package = pkgs.nixFlakes;
    extraOptions = ''
      # https://github.com/nix-community/nix-direnv#home-manager
      keep-outputs = true
      keep-derivations = true

      # Enable the nix 2.0 CLI and flakes support feature-flags
      experimental-features = nix-command flakes
    '';

    settings = {
      # Automate `nix store --optimise`
      auto-optimise-store = true;

      # Required by Cachix to be used as non-root user
      trusted-users = [ "root" "bill" ];
    };
  };

  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp60s0.useDHCP = true;
  networking.interfaces.wlp61s0.useDHCP = true;

  networking.hostName = "bill-alienware";
  networking.extraHosts = ''
    # 0.0.0.0 twitter.com
    # 0.0.0.0 mobile.twitter.com
  '';
  networking.enableIPv6 = false;

  services = {
    printing = {
  # Enable CUPS to print documents.
      enable = true;
      drivers = [ pkgs.cups-brother-hll2350dw ];
    };

    # SSH daemon.
    sshd.enable = true;
  };

  # Enable sound.
  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  environment.pathsToLink = [
    "/share/nix-direnv"
    "/share/zsh"
  ];

  fonts.fonts = with pkgs; [
    ibm-plex
    hasklig
  ];

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkbOptions = "ctrl:swapcaps";
    videoDrivers = [ "nvidia" ];

    # desktopManager.session = [
    #   {
    #     name = "home-manager";
    #     start = ''
    #       ${pkgs.runtimeShell} $HOME/.hm-xsession &
    #       waitPID=$!
    #     '';
    #   }
    # ];
  };
  services.udev.packages = with pkgs; [ solaar ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.groups = {
    hackers = {
      gid = 616;
      members = [ "bill" ];
    };
  };

  users.users = {
    bill = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "networkmanager"
        "docker"
      ];
      hashedPassword = "$6$v410qNk9xVt/PGXW$BSOlqT.HFFk0BwhTgc20qvXdX6Y0fVeiCmse/KdMFMT7h.JGZveS9E31xfTpnPCTifzntwkg/CzRaXY9YlNtV0";
    };

    alice = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
      ];
      home = "/alice";
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpi
    git
    home-manager
    htop
    nano
    unzip
    wget

    libsForQt5.kwin-tiling # kwin tiling
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.nano = {
    nanorc = (import ./nano/nanorc);
    syntaxHighlight = true;
  };

  programs.dconf.enable = true;

  # Enable Docker & VirtualBox support.
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    virtualbox.host = {
      enable = false;
      enableExtensionPack = false;
    };
  };

  users.extraGroups.vboxusers.members = [ "bill" ];

  # Fractal wallpapers
  # services.fractalart.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev"; # or "nodev" for efi only
    efiSupport = true;
    enableCryptodisk = true;
    fontSize = 24;
    configurationLimit = 20;

    # Grub menu is painted really slowly on HiDPI, so we lower the
    # resolution. Unfortunately, scaling to 1280x720 (keeping aspect
    # ratio) doesn't seem to work, so we just pick another low one.
    gfxmodeEfi = "1280x720";
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  boot.initrd.luks.devices = {
    luksroot = {
      device = "/dev/disk/by-uuid/b8ebfccf-85d7-46df-b97c-59008beb151e";
      preLVM = true;
      allowDiscards = true;
    };
  };

  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:swapcaps";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  networking.hostName = "bill-thinkpad";

  console = {
    font = "Hasklig16";
    # font = "Lat2-Terminus16";
    keyMap = "us";
  };

  fonts.fonts = with pkgs; [
    ibm-plex
    hasklig
  ];

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
      ];
      hashedPassword = "$6$v410qNk9xVt/PGXW$BSOlqT.HFFk0BwhTgc20qvXdX6Y0fVeiCmse/KdMFMT7h.JGZveS9E31xfTpnPCTifzntwkg/CzRaXY9YlNtV0";
      # home = "/workspace";
      home = "/home/bill";
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}

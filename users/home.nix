{ config, pkgs, overlays, ... }:
let
  lib = pkgs.lib;

  common_modules = [
    ./modules/cli
    # ./modules/system-management
    ./modules/browsers.nix
    ./modules/communication.nix
    ./modules/git.nix
    ./modules/kitty.nix
    ./modules/media.nix
    ./modules/programming.nix
    ./modules/ssh.nix
  ];

  unfreePredicate = lib: pkg: builtins.elem (lib.getName pkg) [
    "zoom-us"
    "slack"
    "discord"
    "unrar"
    "masterpdfeditor4"
  ];
in
{
  # NOTE: Here we are injecting colorscheme so that it is passed down all the imports
  _module.args = {
    colorscheme = (import ./colorschemes/onedark.nix);
  };

  nixpkgs.config.allowUnfreePredicate = (unfreePredicate lib);
  nixpkgs.overlays = overlays;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
  manual.html.enable = true;
  news.display = "silent";

  imports = common_modules;

  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita-dark";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
  };

  # Packages that don't fit in the modules that we have
  home.packages = with pkgs; [
    aspell
    aspellDicts.en

    audacity
    bitwarden-cli
    hasklig
    libreoffice
    nix-update
    photoqt
    protonvpn-gui

    # Video/image conversion
    # https://jeremyrouet.medium.com/simple-commands-to-learn-ffmpeg-in-real-use-case-a53f4360efa7
    ffmpeg
    libheif

    # connect to iPhone
    ifuse
  ];

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
    theme = "Arc-Dark";
  };

  services.picom = {
    enable = true;
    activeOpacity = 1.0;
    inactiveOpacity = 0.8;
    backend = "glx";
    fade = true;
    fadeDelta = 5;
    opacityRules = [
      "100:name *= 'i3lock'"
    ];
    shadow = true;
    shadowOpacity = 0.75;
  };

  # Background image
  home.file.".background-image".source = ../background.jpg;

  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "bill";
    homeDirectory = "/home/bill";
    keyboard.options = [ "ctrl:nocaps" ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.11";
  };
}

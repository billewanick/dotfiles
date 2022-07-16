{ config, pkgs, overlays, ... }:
let
  lib = pkgs.lib;

  common_modules = [
    ./modules/browsers.nix
    ./modules/cli
    ./modules/communication.nix
    # ./modules/desktop-environment
    ./modules/git.nix
    ./modules/kitty.nix
    ./modules/media.nix
    ./modules/programming.nix
    # ./modules/system-management
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
    colorscheme = (import ./colorschemes/tokyonight.nix);
  };

  nixpkgs.config.allowUnfreePredicate = (unfreePredicate lib);
  nixpkgs.overlays = overlays;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
  manual.html.enable = true;
  news.display = "silent";

  imports = common_modules ++ [
    # ./modules/browser.nix
    # ./modules/desktop-environment
    # ./modules/media.nix
  ];

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

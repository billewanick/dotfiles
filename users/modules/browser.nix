{ config, pkgs, libs, ... }:
let
  ublock-origin-id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
in
{
  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      https-everywhere
      privacy-badger
      bitwarden
      ublock-origin
      facebook-container
      old-reddit-redirect
    ];
    profiles = {
      default = {
        isDefault = true;
        settings = {
          "browser.search.suggest.enabled" = false;
          "browser.tabs.closeWindowWithLastTab" = true;
          "devtools.theme" = "dark";
          "browser.urlbar.placeholderName" = "DuckDuckGo";
        };
      };
    };
  };

  programs.chromium = {
    enable = true;
    extensions = [
      { id = ublock-origin-id; }
    ];
  };

  programs.qutebrowser = { enable = true; };

  home.packages = with pkgs; [
    tor-browser-bundle-bin
  ];

}

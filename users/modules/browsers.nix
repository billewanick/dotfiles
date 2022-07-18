{ config, pkgs, libs, ... }:
let
  # Chrome
  ublock-origin-id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";

  # Firefox
  # disable the annoying floating icon with camera and mic when on a call
  disableWebRtcIndicator = ''
    #webrtcIndicator {
      display: none;
    }
  '';

  # ~/.mozilla/firefox/PROFILE_NAME/prefs.js | user.js
  sharedSettings = {
    "app.normandy.first_run" = false;
    "app.shield.optoutstudies.enabled" = false;

    # disable updates (pretty pointless with nix)
    "app.update.channel" = "default";

    "browser.contentblocking.category" = "standard"; # "strict"
    "browser.ctrlTab.recentlyUsedOrder" = true;

    "browser.download.useDownloadDir" = true;
    "browser.download.viewableInternally.typeWasRegistered.svg" = true;
    "browser.download.viewableInternally.typeWasRegistered.webp" = true;
    "browser.download.viewableInternally.typeWasRegistered.xml" = true;

    "browser.link.open_newwindow" = false;

    "browser.search.region" = "CA";
    "browser.search.suggest.enabled" = false;
    "browser.search.widget.inNavBar" = true;

    "browser.shell.checkDefaultBrowser" = false;
    "browser.startup.homepage" = "https://nixos.org";
    "browser.tabs.closeWindowWithLastTab" = true;
    "browser.tabs.loadInBackground" = true;
    "browser.urlbar.placeholderName" = "DuckDuckGo";
    "browser.urlbar.showSearchSuggestionsFirst" = false;

    "devtools.theme" = "dark";

    "distribution.searchplugins.defaultLocale" = "en-US";

    "doh-rollout.balrog-migration-done" = true;
    "doh-rollout.doneFirstRun" = true;

    "dom.forms.autocomplete.formautofill" = false;

    "general.autoScroll" = true;
    "general.useragent.locale" = "en-US";

    "extensions.activeThemeID" = "firefox-alpenglow@mozilla.org";

    "extensions.extensions.activeThemeID" = "firefox-alpenglow@mozilla.org";
    "extensions.update.enabled" = false;
    "extensions.webcompat.enable_picture_in_picture_overrides" = true;
    "extensions.webcompat.enable_shims" = true;
    "extensions.webcompat.perform_injections" = true;
    "extensions.webcompat.perform_ua_overrides" = true;

    "print.print_footerleft" = "";
    "print.print_footerright" = "";
    "print.print_headerleft" = "";
    "print.print_headerright" = "";

    "privacy.donottrackheader.enabled" = true;

    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  };
in
{
  programs.firefox = {
    enable = true;

    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      bitwarden
      facebook-container
      https-everywhere
      i-dont-care-about-cookies # auto-accepts cookies, use only with privacy-badger & ublock-origin
      link-cleaner
      old-reddit-redirect
      privacy-badger
      ublock-origin
      unpaywall
    ];

    package = pkgs.firefox-beta-bin;

    profiles = {
      default = {
        id = 0;
        isDefault = true;
        settings = sharedSettings;
        userChrome = disableWebRtcIndicator;
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

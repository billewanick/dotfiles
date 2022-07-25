{
  services.xserver = {
    enable = true;

    extraLayouts.us-custom = {
      description = "US layout with custom hyper keys";
      languages = [ "eng" ];
      symbolsFile = ./us-custom.xkb;
    };

    # layout = "us-custom";

    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = false;
        enableXfwm = false;
      };
    };

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
      config = ./config.hs;
    };

    displayManager.defaultSession = "xfce+xmonad";
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "bill";

    xkbOptions = "ctrl:swapcaps";
    libinput = {
      enable = true;
      touchpad.disableWhileTyping = true;
    };
  };
}

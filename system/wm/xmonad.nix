{
  services.xserver = {
    enable = true;

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

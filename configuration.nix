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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  time.hardwareClockInLocalTime = true;

  # nix = {
  #   package = pkgs.nixUnstable;
  #   extraOptions = ''
  #     experimental-features = nix-command flakes
  #   '';
  # };

  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp60s0.useDHCP = true;
  networking.interfaces.wlp61s0.useDHCP = true;
  networking.networkmanager.enable = true;

  networking.hostName = "bill-alienware";
  networking.extraHosts = ''
    # 0.0.0.0 twitter.com
    # 0.0.0.0 mobile.twitter.com
  '';
  networking.enableIPv6 = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.cups-brother-hll2350dw ];

  # Enable sound.
  sound.enable = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.enable = true;

    environment.pathsToLink = [
    "/share/nix-direnv"
    "/share/zsh"
  ];

  fonts.fonts = with pkgs; [
    ibm-plex
    hasklig
  ];

  virtualisation.docker.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkbOptions = "ctrl:swapcaps";

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.xserver = {
    # enable = true;

    # # Configure keymap in X11
    # layout = "us";
    # xkbOptions = "ctrl:swapcaps";

    # libinput.enable = true;
    # synaptics.enable = false;

    # desktopManager = {
    #   xterm.enable = false;

    #   xfce = {
    #     enable = true;
    #     noDesktop = false;
    #     enableXfwm = false;
    #   };

    #   cinnamon.enable = false;
    #   mate.enable = false;
    #   plasma5.enable = false;

    # };

    # windowManager = {

    #   xmonad = {
    #     enable = true;
    #     enableContribAndExtras = true;
    #     extraPackages = haskellPackages: [
    #       haskellPackages.xmonad
    #       haskellPackages.xmonad-contrib
    #       haskellPackages.xmonad-extras
    #     ];
    #     config = ''
    #       import XMonad
    #       import XMonad.Config.Xfce
    #       main = xmonad xfceConfig
    #             { terminal = "alacritty"
    #             , modMask = mod4Mask -- optional: use Win key instead of Alt as MODi key
    #             }
    #     '';
    #   };
    # };

    # displayManager = {

    #   defaultSession = "none+xmonad";
    #   # defaultSession = "xfce";
    #   # defaultSession = "plasma";
    #   # sddm.enable = true;
    #   autoLogin.enable = true;
    #   autoLogin.user = "bill";


    #   lightdm = {
    #     enable = true;
    #     background = "./background.jpg";
    #     greeters.tiny.enable = true;
    #   };
    # };

  };

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    htop
    nano
    wget

    # Source Contorl Management
    fossil
    git
    pijul

    # Databases
    postgresql
    sqlite

    # Utility
    acpi
    alacritty
    aspell
    aspellDicts.en
    direnv
    home-manager
    nix-direnv
    tealdeer
    xclip
    unzip
    i3lock
    photoqt

    # Video/image conversion
    # https://jeremyrouet.medium.com/simple-commands-to-learn-ffmpeg-in-real-use-case-a53f4360efa7
    ffmpeg
    libheif

    # connect to iPhone
    ifuse

    gimp

    # Communication
    element-desktop
    signal-desktop
    tor-browser-bundle-bin

    # Music
    amarok
    gpodder

    # XMonad-related
    dmenu
    taffybar
    volumeicon
    xfce.thunar
    xfce.xfce4-panel

    # kwin tiling
    libsForQt5.kwin-tiling

    # Development
    #   Shells
    zsh-nix-shell
    zsh-powerlevel10k

    # Languages
    #   Nix
    nixpkgs-fmt
    nixpkgs-lint
    nixpkgs-review
    editorconfig-checker

    #   Glasgow Haskell Compiler
    ghc
    ghcid

    #   Purescript
    # nodePackages.pscid
    # purescript
    # spago

    #   Misc Langs
    chez
    idris2
    owl-lisp
    racket
    red
    zig

    # https://discourse.nixos.org/t/debugging-broken-builds/3138/4
    cntr

    (pkgs.writeShellScriptBin "nixFlakes" ''
      exec ${pkgs.nixUnstable}/bin/nix --experimental-features "nix-command flakes" "$@"
    '')

    # xfce.xfce4-pulseaudio-plugin
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?


  # TODO: Move nano to own file
  programs.nano = {
    nanorc =
      ''
        # Use auto-indentation
        set autoindent

        # Backup files to filename~
        # set backup

        # Enable ~/.nano_history for saving and reading search/replace strings.
        set historylog

        # Don't convert files from DOS/Mac format
        set noconvert

        set linenumbers

        # Use smooth scrolling as the default
        # set smooth

        # Use this spelling checker instead of the internal one.  This option
        # does not properly have a default value.
        set speller "aspell -c"

        # Allow nano to be suspended with ^Z
        set suspend

        # Use this tab size instead of the default; it must be greater than 0
        set tabsize 2

        # Save automatically on exit, don't prompt
        set tempfile

        # Disallow file modification, why would you want this in an rc file? ;)
        # set view

        #Color Syntax Highlighting
        syntax "c-file" "\.(c|h)$"
        color red "\<[A-Z_]{2,}\>"
        color green "\<(float|char|int|void|static|const|struct)\>"
        color brightyellow "\<(if|while|do|else|case|switch)\>"
        color brightcyan "^#(  )*(define|include|ifn?def|endif|elif|else|if)"
        color brightyellow "<[^=       ]*>" ""(.|[^"])*""
        color brightyellow start=""(\\.|[^\"])*\\( |   )*$" end="^(\\.|[^\"])*""
        color brightblue "//.*"
        color brightblue start="/\*" end="\*/"

        syntax "HTML" "\.html$"
        color blue start="<" end=">"
        color red "&[^;        ]*;"

        syntax "Javasource" "\.java$"
        color green "\<(boolean|byte|char|double|float|int|long|new|short|this|transient|void)\>"
        color red "\<(break|case|catch|continue|default|do|else|finally|for|if|return|switch|throw|try|while)\>"
        color cyan "\<(abstract|class|extends|final|implements|import|instanceof|interface|native|package|private|protected|public|static|strictfp|super|synchronized|throws|volatile)\>"
        color red ""[^"]*""
        color yellow "<(true|false|null)>"
        color blue "//.*"
        color blue start="/\*" end="\*/"
        color brightblue start="/\*\*" end="\*/"
        color brightgreen,brightgreen "[       ]+$"

        syntax "nanorc" "[\.]*nanorc$"
        color white "^ *(set|unset).*$"
        color cyan "^ *(set|unset) (autoindent|backup|const|cut|fill|keypad|multibuffer|noconvert|nofollow|nohelp|nowrap|operatingdir|preserve|quotestr|regexp|smooth|speller|suspend|tabsize|tempfile|historylog|view)"
        color brightwhite "^ *syntax [^ ]*"
        color brightblue "^ *set\>" "^ *unset\>" "^ *syntax\>"
        color white "^ *color\>.*"
        color yellow "^ *color (bright)?(white|black|red|blue|green|yellow|magenta|cyan)\>"
        color magenta "^ *color\>"
        color green "^#.*$"

        syntax "bash" "\.sh$"
        color brightblack "#.*"
        color brightyellow "\(" "\)" "\{" "\}"
        color red "\<[A-Z_]{2,}\>"
        color red "[\$\*\'\`\|\=]"
        color brightblue "\[.*\]"
        color green "\<-e\>" "\<-d\>" "\<-f\>" "\<-r\>" "\<-g\>" "\<-u\>" "\<-u\>" "\<-w\>" "\<-x\>" "\<-L\>"
        color green "\<-eq\>" "\<-ne\>" "\<-gt\>" "\<-lt\>" "\<-ge\>" "\<-le\>" "\<-s\>" "\<-n\>" "\<-z\>"
        color blue "\" "\" "\" "\" "\" "\" "\" "\" "\"
        color blue "\" "\" "\" "\" "\"
        color brightwhite "\.*"

        syntax "haskell" "\.hs$"

        ## Keywords
        color red "[ ](as|case|of|class|data|default|deriving|do|forall|foreign|hiding|if|then|else|import|infix|infixl|infixr|instance|let|in|mdo|module|newtype|qualified|type|where)[ ]"
        color red "(^data|^foreign|^import|^infix|^infixl|^infixr|^instance|^module|^newtype|^type)[ ]"
        color red "[ ](as$|case$|of$|class$|data$|default$|deriving$|do$|forall$|foreign$|hiding$|if$|then$|else$|import$|infix$|infixl$|infixr$|instance$|let$|in$|mdo$|module$|newtype$|qualified$|type$|where$)"

        ## Various symbols
        color cyan "(\||@|!|:|_|~|=|\\|;|\(\)|,|\[|\]|\{|\})"

        ## Operators
        color magenta "(==|/=|&&|\|\||<|>|<=|>=)"

        ## Various symbols
        color cyan "(->|<-)"
        color magenta "\.|\$"

        ## Data constructors
        color magenta "(True|False|Nothing|Just|Left|Right|LT|EQ|GT)"

        ## Data classes
        color magenta "[ ](Read|Show|Enum|Eq|Ord|Data|Bounded|Typeable|Num|Real|Fractional|Integral|RealFrac|Floating|RealFloat|Monad|MonadPlus|Functor)"

        ## Strings
        color yellow ""[^\"]*""

        ## Comments
        color green "--.*"
        color green start="\{-" end="-\}"

        color brightred "undefined"

        linter hlint
      '';
    syntaxHighlight = true;
  };
}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  # TODO: Move vscode to own file
  extensions = (with pkgs.vscode-extensions; [
    # bbenoist.Nix
    formulahendry.code-runner
    jnoortheen.nix-ide
    yzhang.markdown-all-in-one
    davidanson.vscode-markdownlint
    zhuangtongfa.material-theme
    dracula-theme.theme-dracula
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    # TODO: Add all these to nixpkgs and/or update them
    {
      name = "Kotlin";
      publisher = "mathiasfrohlich";
      version = "1.7.1";
      sha256 = "32e0255fa71d60c2d8457dac2e76b15b374d3dc6781b415d7f4e1f9a7cd0287e";
    }
    {
      name = "kotlin-formatter";
      publisher = "esafirm";
      version = "0.0.6";
      sha256 = "1fd8a3d4f6d2cb5bbb9d73c9fc25b56e40cfd599f378feb12cce8eec23688703";
    }
    {
      name = "Nix";
      publisher = "bbenoist";
      version = "1.0.1";
      sha256 =
        "ab0c6a386b9b9507953f6aab2c5f789dd5ff05ef6864e9fe64c0855f5cb2a07d";
    }
    {
      name = "nix-env-selector";
      publisher = "arrterian";
      version = "0.1.7";
      sha256 =
        "0e76885c9dbb6dca4eac8a75866ec372b948cc64a3a3845327d7c3ef6ba42a57";
    }
    {
      name = "haskell";
      publisher = "haskell";
      version = "1.6.0";
      sha256 =
        "3c3ab17d2ece9986edef5b18685852e627bb42daad7b333d4b305b7a2c3fc805";
    }
    {
      name = "vscode-hsx";
      publisher = "s0kil";
      version = "0.3.1";
      sha256 =
        "2b62fd1ab15b5eefc0c5d813a00b9a5bd3d746e520531f6b1ddeccaa2985513f";
    }
    {
      name = "language-haskell";
      publisher = "justusadam";
      version = "3.4.0";
      sha256 = "fe989d59bc93fa1807ec6b2554060ad6ee51266312bccaa3ea72aafe65a96729";
    }
  ];
  vscodium-with-extensions = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscodium;
    # vscode = pkgs.vscode;
    vscodeExtensions = extensions;
  };
in
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

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  networking.hostName = "bill-thinkpad";

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
    direnv
    home-manager
    nix-direnv
    tealdeer
    xclip

    # Communication
    element-desktop

    # XMonad-related
    dmenu
    taffybar
    volumeicon
    xfce.thunar
    xfce.xfce4-panel

    # Development
    vscodium-with-extensions

    #   Shells
    zsh-nix-shell
    zsh-powerlevel10k

    # Languages
    #   Nix
    nixpkgs-fmt
    nixpkgs-lint
    nixpkgs-review

    #   Glasgow Haskell Compiler
    ghc
    ghcid

    #   Purescript
    nodePackages.pscid
    purescript
    spago

    #   Misc Langsnixpkgs
    chez
    idris2
    owl-lisp
    racket
    red
    zig
  ];

  environment.pathsToLink = [
    "/share/nix-direnv"
    "/share/zsh"
  ];

  console = {
    font = "Hasklig16";
    # font = "Lat2-Terminus16";
    keyMap = "us";
  };

  fonts.fonts = with pkgs; [
    ibm-plex
    hasklig
  ];

  services.xserver = {
    enable = true;

    # Configure keymap in X11
    layout = "us";
    xkbOptions = "ctrl:swapcaps";

    libinput.enable = true;
    synaptics.enable = false;

    desktopManager = {
      xterm.enable = false;

      xfce = {
        enable = true;
        noDesktop = false;
        enableXfwm = false;
      };

      enlightenment.enable = true;
      cinnamon.enable = true;
      mate.enable = true;
      plasma5.enable = true;

    };

    windowManager = {

      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmonad
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
        ];
        config = ''
          import XMonad
          import XMonad.Config.Xfce
          main = xmonad xfceConfig
                { terminal = "alacritty"
                , modMask = mod4Mask -- optional: use Win key instead of Alt as MODi key
                }
        '';
      };

      i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };

    };

    displayManager = {

      defaultSession = "none+xmonad";
      sddm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "bill";

    };

  };

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

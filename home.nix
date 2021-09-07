# Home-manager config
{ config, pkgs, ... }:
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bill";
  home.homeDirectory = "/home/bill";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  home.packages = with pkgs; [
    zsh-nix-shell
    zsh-powerlevel10k

    hasklig
  ];

  fonts.fontconfig.enable = true;
  home.keyboard.options = [ "ctrl:nocaps" ];

  manual.html.enable = true;
  news.display = "silent";

  programs = {
    bat = {
      enable = true;
      config = {
        pager = "less -FR";
        theme = "TwoDark";
      };
      themes = {
        dracula = builtins.readFile (pkgs.fetchFromGitHub
          {
            owner = "dracula";
            repo = "sublime"; # Bat uses sublime syntax for its themes
            rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
            sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
          } + "/Dracula.tmTheme");
      };
    };

    chromium = {
      enable = true;
      extensions = [ "cjpalhdlnbpafiamejdnhcphjbkeiagm" ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      nix-direnv.enableFlakes = true;
      stdlib = ''

      '';
    };

    emacs = {
      enable = true;
      extraPackages = epkgs: [ epkgs.nix-mode epkgs.magit ];
    };

    firefox = {
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

    fzf.enable = true;

    git = {
      package = pkgs.gitAndTools.gitFull;
      enable = true;
      userName = "Bill Ewanick";
      userEmail = "bill@ewanick.com";
      aliases = {
        # s = "status";
        # co = "checkout";
      };
      extraConfig = { init = { defaultBranch = "main"; }; };

      delta.enable = true;
    };

    keychain = {
      enable = true;
      enableZshIntegration = true;
      keys = [ "id_ed25519" "id_gitlab" ];
    };

    qutebrowser = { enable = true; };

    rofi = { enable = true; };

    rtorrent = { enable = true; };

    ssh = {
      enable = true;
      forwardAgent = true;
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
          identitiesOnly = true;
        };
        "gitlab.com" = {
          hostname = "gitlab.com";
          user = "git";
          identityFile = [ "${config.home.homeDirectory}/.ssh/id_gitlab" ];
          identitiesOnly = true;
        };
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = { add_newline = false; };
    };

    taskwarrior = { enable = true; };

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      # package = pkgs.vscode;
      extensions = [
        # pkgs.vscode-extensions.bbenoist.Nix
        pkgs.vscode-extensions.jnoortheen.nix-ide
        pkgs.vscode-extensions.yzhang.markdown-all-in-one
        pkgs.vscode-extensions.davidanson.vscode-markdownlint
        pkgs.vscode-extensions.zhuangtongfa.material-theme
        pkgs.vscode-extensions.dracula-theme.theme-dracula
        # pkgs.vscode-extensions.haskell.haskell
        pkgs.vscode-extensions.streetsidesoftware.code-spell-checker
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        ########################################33
        # TODO: Add all these to nixpkgs and/or update them
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

      # userSettings = {

      # };
    };

    zathura = {
      enable = true;
      extraConfig =
        "\n        map <C-i> zoom in\n        map <C-o> zoom out\n      ";
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      autocd = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "command-not-found"
          "cp"
          "ssh-agent"
          "node"
          "npm"
          "themes"
        ];
        theme = "pygmalion";
      };
      shellAliases = {
        # Navigation
        ".." = "cd ..";
        home = "cd /workspace";

        # Program enhancement defaults
        cat = "bat";
        nano = "nano -EPcl";
        # ls = "ls -lha";

        # Curling APIs
        weather = "curl wttr.in/Ottawa";

        # Disabling laptop trackpad
        # https://askubuntu.com/questions/67718/how-do-i-disable-a-touchpad-using-the-command-line
        disableTrackpad = "xinput set-prop $(xinput list --id-only 'Synaptics TM3288-011') 'Device Enabled' 0";
        enableTrackpad = "xinput set-prop $(xinput list --id-only 'Synaptics TM3288-011') 'Device Enabled' 1";

        battery = "acpi";

        # Laptop Brightness
        brightness = "xrandr --output eDP-1 --brightness ";
        # brightnessX = brightness ++ "0.2";
        brightnessDim = "xrandr --output eDP1 --brightness 0.1";
        brightnessFull = "xrandr --output eDP1 --brightness 1.0";
        brightnessMid = "xrandr --output eDP1 --brightness 0.5";

        # Git aliases
        gs = "git status";
        gc = "git commit -a -m";
        gd = "git diff";
        gr = "git reset HEAD .";
        gl = "git log";
        gb = "git branch";
        gco = "git checkout -";
        # git undo, dangerous to repeat!
        # undo = "git reset --soft HEAD^"

        # Kitty terminal clear command
        # printf '\033[2J\033[3J\033[1;1H'
      };
      initExtra = ''
        nixify() {
          if [ ! -e ./.envrc ]; then
            echo "use nix" > .envrc
            direnv allow
          fi
          if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
            cat > default.nix <<'EOF'
        with import <nixpkgs> {};
        mkShell {
          nativeBuildInputs = [
            bashInteractive
          ];
        }
        EOF
            ${EDITOR:-vim} default.nix
          fi
        }

        flakifiy() {
          if [ ! -e flake.nix ]; then
            nix flake new -t github:nix-community/nix-direnv .
          elif [ ! -e .envrc ]; then
            echo "use flake" > .envrc
            direnv allow
          fi
          ${EDITOR:-vim} flake.nix
        }

        # Powerlevel10k
        # https://github.com/evanjs/nixos_cfg/blob/ee9244012e12d8f3d03453de35a0d6e7f14bb4b8/config/new-modules/zsh.nix#L24
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ~/.p10k.zsh

        # I'm running VSCode inside WSL because it's managed by home-manager
        # To disable the warning from the terminal
        # export DONT_PROMPT_WSL_INSTALL="dontPromptMe"

        # https://medium.com/@japheth.yates/the-complete-wsl2-gui-setup-2582828f4577
        # For getting X-Server apps installed with Nix running on Windows 10
        # export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
        # export LIBGL_ALWAYS_INDIRECT=1
        # sudo /etc/init.d/dbus start &> /dev/null

        # -z is true if length of string is zero.
        if [ -z $IN_NIX_SHELL ]; then
          # New terminal, go to home
          cd /workspace
        else
          if [ $IN_NIX_SHELL = "impure" ]; then
            # Stay in the current shell
          fi
        fi
      '';
    };
  };

  # home.file.".ssh/id_rsa" = {
  #   text = builtins.readFile ./secrets/id_rsa;
  #   onChange = "sudo chmod 700 ~/.ssh/id_rsa";
  # };
  # home.file.".ssh/id_rsa.pub" = {
  #   text = builtins.readFile ./keys/id_rsa.pub;
  #   onChange = "sudo chmod 644 ~/.ssh/id_rsa.pub";
  # };
  # home.sessionVariables = theme // {
  #   BROWSER = "brave";
  #   EDITOR = "vim";
  #   COMPLICE_TOKEN = builtins.readFile ./secrets/complice_api;
  # };

}

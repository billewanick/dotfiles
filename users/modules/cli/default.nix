{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    # CLI tools / Terminal facification
    unzip
    jq
    unrar

    # Moar colors
    zsh-syntax-highlighting

    # Searching/Movement helpers
    fzf
    ripgrep

    # system info
    bottom

    # benchmarking
    httperf

    # zsh related
    zsh-nix-shell
    zsh-powerlevel10k
  ];

  programs.bat = {
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    stdlib = ''

      '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tealdeer = {
    enable = true;
    settings = {
      display = {
        compact = false;
        use_pager = false;
      };
      updates = {
        auto_update = false;
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    shellAliases = (import ./zsh/aliases.nix);
    history.extended = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./zsh;
        file = "p10k.zsh";
      }
    ];

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
      ];
    };

    initExtra = ''

    '';

    initExtraBeforeCompInit = ''
      ${builtins.readFile ./zsh/sessionVariables.zsh}
      ${builtins.readFile ./zsh/functions.zsh}
      eval "$(direnv hook zsh)"
    '';
  };
}

# To put in initExtraBeforeCompInit once I figure out how secrets work
# ${builtins.readFile ../../../.secrets/env-vars.sh}

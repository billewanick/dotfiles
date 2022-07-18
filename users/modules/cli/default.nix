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

  programs.keychain = {
    enable = false;
    enableZshIntegration = true;
    keys = [ "id_ed25519" "id_gitlab" ];
  };

  programs.tealdeer = {
    enable = true;
    settings = {
      display = {
        compact = false;
        use_pager = true;
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
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "command-not-found"
        "cp"
        # "ssh-agent"
        "node"
        "npm"
        "themes"
      ];
      theme = "pygmalion";
    };

    initExtra = ''
      # Powerlevel10k
      # https://github.com/evanjs/nixos_cfg/blob/ee9244012e12d8f3d03453de35a0d6e7f14bb4b8/config/new-modules/zsh.nix#L24
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ~/.p10k.zsh

      # If to always go to home, unless nix-shell stay in folder
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

    initExtraBeforeCompInit = ''
      ${builtins.readFile ./zsh/sessionVariables.zsh}
      ${builtins.readFile ./zsh/functions.zsh}
      eval "$(direnv hook zsh)"
    '';
  };
}

# To put in initExtraBeforeCompInit once I figure out how secrets work
# ${builtins.readFile ../../../.secrets/env-vars.sh}

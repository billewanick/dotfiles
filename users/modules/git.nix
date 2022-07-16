{ config, pkgs, libs, ... }:
{
  home.packages = with pkgs; [
    git-crypt
    gitAndTools.delta
    hub
  ];

  programs.git = {
    enable = true;
    userName = "Bill Ewanick";
    userEmail = "bill@ewanick.com";
    package = pkgs.gitAndTools.gitFull;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };

      core = {
        pager = "delta";
        editor = "codium";
      };

      pull.ff = "only";

      delta = {
        features = "side-by-side line-numbers decorations";
      };
      "delta \"decorations\"" = {
        commit-decoration-style = "bold yellow box ul";
        file-style = "bold yellow";
        file-decoration-style = "none";
      };
    };
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;

  # home.file.".ssh/id_rsa" = {
  #   text = builtins.readFile ./secrets/id_rsa;
  #   onChange = "sudo chmod 700 ~/.ssh/id_rsa";
  # };
  # home.file.".ssh/id_rsa.pub" = {
  #   text = builtins.readFile ./keys/id_rsa.pub;
  #   onChange = "sudo chmod 644 ~/.ssh/id_rsa.pub";
  # };
}

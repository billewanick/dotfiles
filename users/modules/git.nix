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
      push.autoSetupRemote = true;

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
}

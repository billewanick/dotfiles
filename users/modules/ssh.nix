{ config, pkgs, libs, ... }:
{

  programs.keychain = {
    enable = false;
    enableZshIntegration = true;
    keys = [ "id_ed25519" "id_gitlab" ];
  };

  programs.ssh = {
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
}

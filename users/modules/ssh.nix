{ config, pkgs, libs, ... }:
{

  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    keys = [ "id_ed25519" ];
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
        identityFile = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
        identitiesOnly = true;
      };
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
}

{
  description = "Home manager flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    taffybar = {
      url = "github:sherubthakur/taffybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, nur, taffybar, ... }@inputs:
    let
      overlays = [
        nur.overlay
        taffybar.overlay
      ];

      unfreePredicate = lib: pkg: builtins.elem (lib.getName pkg) [
        "zoom-us"
        "slack"
        "discord"
        "unrar"
        "masterpdfeditor4"
      ];

      common_modules = [
        ./modules/browser.nix
        ./modules/cli
        # ./modules/desktop-environment
        ./modules/git.nix
        ./modules/kitty.nix
        ./modules/media.nix
        ./modules/programming.nix
        # ./modules/system-management
        ./modules/ssh.nix
      ];

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
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
    in
    {
      homeConfigurations = {
        nixos = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            {
              # NOTE: Here we are injecting colorscheme so that it is passed down all the imports
              _module.args = {
                colorscheme = (import ./colorschemes/tokyonight.nix);
              };

              nixpkgs.config.allowUnfreePredicate = (unfreePredicate lib);
              nixpkgs.overlays = overlays;

              # Let Home Manager install and manage itself.
              programs.home-manager.enable = true;

              fonts.fontconfig.enable = true;
              manual.html.enable = true;
              news.display = "silent";

              imports = common_modules ++ [
                # ./modules/browser.nix
                # ./modules/desktop-environment
                # ./modules/media.nix
              ];

              # Packages that don't fit in the modules that we have
              home.packages = with pkgs; [
                hasklig
                nix-update
                libreoffice
                protonvpn-gui
                # protonvpn-cli
              ];
            }

            {
              home = {
                homeDirectory = "/home/bill";
                username = "bill";
                keyboard.options = [ "ctrl:nocaps" ];
                # This value determines the Home Manager release that your
                # configuration is compatible with. This helps avoid breakage
                # when a new Home Manager release introduces backwards
                # incompatible changes.
                #
                # You can update Home Manager without changing this value. See
                # the Home Manager release notes for a list of state version
                # changes in each release.
                stateVersion = "22.11";
              };
            }
          ];
        };
      };
    };
}

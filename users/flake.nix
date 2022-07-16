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
    in
    {
      homeConfigurations = {
        nixos = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./home.nix
          ];

          extraSpecialArgs = { inherit overlays; };
        };
      };
    };
}

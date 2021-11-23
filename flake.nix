{
  description = "My NixOS config";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "/workspace/nixpkgs";

    # nix.url = "github:NixOS/nix";

    flake-utils.url = "github:numtide/flake-utils";

    nur.url = "github:/nix-community/NUR";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs =
    { self
    , nixpkgs
      # , nix
    , flake-utils
    , nur
    , nixos-hardware
    , home-manager
    , agenix
    , ...
    }:
    let
      overlays = [
        nur.overlay
        # nix.overlay
      ];
    in
    {
      nixosConfigurations.bill-thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [

          ({ pkgs, ... }: {
            # Flake related nix-pkgs configs
            nixpkgs.overlays = overlays;

            nixpkgs.config.allowUnfree = true;

            nix.package = pkgs.nixFlakes;
            nix.extraOptions = ''
              # https://github.com/nix-community/nix-direnv#home-manager
              keep-outputs = true
              keep-derivations = true

              # Enable the nix 2.0 CLI and flakes support feature-flags
              experimental-features = nix-command flakes
            '';

            home-manager.useGlobalPkgs = true;

          })

          nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen

          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bill = import ./home.nix;
          }

          agenix.nixosModules.age

        ];

      };

    };

}

{
  description = "My NixOS config";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    nur.url = "github:/nix-community/NUR";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, flake-utils, nixos-hardware, home-manager, nixpkgs, nur, ... }:
    let
      overlays = [ nur.overlay ];
    in
    {
      nixosConfigurations.bill-thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [

          {
            nixpkgs.overlays = overlays;
            nixpkgs.config.allowUnfree = true;
          }

          nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen

          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bill = import ./home.nix;
          }

        ];

      };

    };

}

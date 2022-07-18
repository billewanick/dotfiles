{ config, pkgs, lib, ... }:

let
  defaultPackages = with pkgs; [
    # Source Contorl Management
    fossil
    pijul

    # Databases
    postgresql
    sqlite

    # Nix
    nixpkgs-fmt
    nixpkgs-lint
    nixpkgs-review
    editorconfig-checker

    # Purescript
    nodePackages.pscid
    purescript
    spago

    # Misc Langs
    chez
    idris2
    owl-lisp
    racket
    red
    zig
  ];

  haskellPackages = with pkgs.haskellPackages; [
    # Glasgow Haskell Compiler
    ghc
    ghcid
    hoogle
    nix-tree
  ];
in
{
  home.packages =
    defaultPackages
    ++ haskellPackages;

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    # package = pkgs.vscode;
    extensions = [
      pkgs.vscode-extensions.streetsidesoftware.code-spell-checker
      pkgs.vscode-extensions.dracula-theme.theme-dracula

      pkgs.vscode-extensions.haskell.haskell
      pkgs.vscode-extensions.justusadam.language-haskell

      pkgs.vscode-extensions.yzhang.markdown-all-in-one
      pkgs.vscode-extensions.davidanson.vscode-markdownlint

      pkgs.vscode-extensions.bbenoist.nix
      pkgs.vscode-extensions.arrterian.nix-env-selector
      pkgs.vscode-extensions.jnoortheen.nix-ide

      pkgs.vscode-extensions.zhuangtongfa.material-theme

    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [

      # TODO: Add all these to nixpkgs and/or update them
      {
        name = "vscode-hsx";
        publisher = "s0kil";
        version = "0.3.1";
        sha256 =
          "2b62fd1ab15b5eefc0c5d813a00b9a5bd3d746e520531f6b1ddeccaa2985513f";
      }
    ];

    # userSettings = {

    # };
  };
}

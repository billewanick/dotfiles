#!/bin/sh
pushd /workspace/nix-new
home-manager switch --flake "./users#nixos"
popd
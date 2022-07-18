#!/bin/sh
pushd /workspace/nix-new
sudo nixos-rebuild switch --flake './system#nixos'
popd
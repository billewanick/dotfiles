#!/bin/sh
pushd /workspace/dotfiles
sudo nixos-rebuild switch --flake './system#nixos'
popd
#!/bin/sh
pushd /workspace/dotfiles
home-manager switch --flake "./users#nixos"
popd
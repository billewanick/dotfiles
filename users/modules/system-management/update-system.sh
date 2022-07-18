#!/bin/sh
pushd /workspace/dotfiles
sudo nix flake update ./system
popd
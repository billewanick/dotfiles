#!/bin/sh
pushd /workspace/nix-new
sudo nix flake update ./system
popd
#!/bin/sh
pushd /workspace/dotfiles
nix flake update ./users
popd
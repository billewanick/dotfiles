#!/bin/sh
pushd /workspace/nix-new
nix flake update ./users
popd
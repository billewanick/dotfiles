function flakifiy() {
  if [ ! -e flake.nix ]; then
    nix flake new -t github:nix-community/nix-direnv .
  elif [ ! -e .envrc ]; then
    echo "use flake" > .envrc
    direnv allow
  fi
}

# If to always go to home, unless nix-shell stay in folder
# -z is true if length of string is zero.
if [ -z $IN_NIX_SHELL ]; then
  # New terminal, go to home
  cd /workspace
else
  if [ $IN_NIX_SHELL = "impure" ]; then
    # Stay in the current shell
  fi
fi

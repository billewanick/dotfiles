{ pkgs, ... }:
{
  home.packages = with pkgs; [
    element-desktop
    signal-desktop

    zoom-us
    slack
    discord
  ];
}

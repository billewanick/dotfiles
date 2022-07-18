{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc

    # Music
    amarok
    gpodder

    gimp

    masterpdfeditor4
  ];

  programs.zathura = {
    enable = true;
    extraConfig = ''
      map <C-i> zoom in
      map <C-o> zoom out
    '';
  };
}

{
  # Navigation;
  ".." = "cd ..";
  "..." = "cd ../..";
  "...." = "cd ../../..";
  "....." = "cd ../../../..";
  home = "cd /workspace";

  # Program enhancement defaults
  cat = "bat";
  nano = "nano -EPcl";
  ls = "ls -lha";

  # Curling APIs
  weather = "curl wttr.in/Ottawa";

  # Disabling laptop trackpad
  # https://askubuntu.com/questions/67718/how-do-i-disable-a-touchpad-using-the-command-line
  disableTrackpad = "xinput set-prop $(xinput list --id-only 'Synaptics TM3288-011') 'Device Enabled' 0";
  enableTrackpad = "xinput set-prop $(xinput list --id-only 'Synaptics TM3288-011') 'Device Enabled' 1";

  battery = "acpi";

  # Laptop Brightness
  brightness = "xrandr --output eDP-1 --brightness ";
  # brightnessX = brightness ++ "0.2";
  brightnessDim = "xrandr --output eDP1 --brightness 0.1";
  brightnessFull = "xrandr --output eDP1 --brightness 1.0";
  brightnessMid = "xrandr --output eDP1 --brightness 0.5";

  # Git aliases
  gs = "git status";
  gc = "git commit -a -m";
  gd = "git diff";
  gr = "git reset HEAD .";
  gl = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
  gb = "git branch";
  gco = "git checkout -";
  gir = "git rebase -i";
  # git undo, dangerous to repeat!
  # undo = "git reset --soft HEAD^"

  # Grep;
  grep = "grep --color=auto";
  nix-stray-roots = "nix-store --gc --print-roots | egrep -v \"^(/nix/var|/run/\w+-system|\{memory)\"";

  # You know (sudoing);
  # If the last character of the value is a blank, then the next command word following
  # the; is also checked for expansion.; So this is just a nice way of making sure your
  # commands are evaluated for aliases before being; passed over to sudo, which ends
  # up being pretty useful.;
  sudo = "sudo ";
  fucking = "sudo ";
  holdmybeer = "sudo ";
}

with import ../../../util;

{ pkgs }:
let

  screens = {
    native = "eDP1";
    main = "HDMI3";
    side = "DP2";
  };

  aliases = {

    screens-1 = with screens; withPath [pkgs.xorg.xrandr] ''

      xrandr --output ${native} --mode 1440x900 --primary \
             --output ${main} --off \
             --output ${side} --off
    '';

    screens-2 = with screens; withPath [pkgs.xorg.xrandr] ''

      xrandr --output ${native} --off \
             --output ${main} --primary --auto --right-of ${native} \
             --output ${side} --auto --right-of ${main}
    '';

    screens-3 = with screens; withPath [pkgs.xorg.xrandr] ''

      xrandr --noprimary --output ${native} --mode 1440x900 \
             --output ${main} --auto --right-of ${native} \
             --output ${side} --auto --right-of ${main}
    '';



  };
in
mkAliases aliases

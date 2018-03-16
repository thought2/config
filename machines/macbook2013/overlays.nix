with import ../../util;
with import <nixpkgs> {};
with lib;

let

  screens = {
    native = "eDP1";
    main = "HDMI3";
    side = "DP1";
  };

in

{ config, ... }:
self: super: {

  screens-1 = with screens; writeShellScriptBin "screens-1" (withPath [pkgs.xorg.xrandr] ''

    xrandr --output ${native} --mode 1440x900 \
           --output ${main} --off \
           --output ${side} --off \
  '');

  screens-2 = with screens; writeShellScriptBin "screens-2" (withPath [pkgs.xorg.xrandr] ''

    xrandr --output ${native} --off \
           --output ${main} --primary --auto --right-of ${native} \
           --output ${side} --auto --right-of ${main} \
  '');

  screens-3 = with screens; writeShellScriptBin "screens-3" (withPath [pkgs.xorg.xrandr] ''

    xrandr --output ${native} --mode 1440x900 \
           --output ${main} --auto --right-of ${native} \
           --output ${side} --auto --right-of ${main} \
  '');

}

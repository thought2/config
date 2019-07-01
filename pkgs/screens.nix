{ pkgs, ... }:

with import ../util;
with pkgs;

let
  screens = {
    native = "eDP-1";
    side = "DP-1";
  };

  screens-alt = {
    native = "eDP1";
    side = "DP1";
  };
in
{
  screens-1 = writeShellScriptBin "screens-1" ''
    ${pkgs.xorg.xrandr}/bin/xrandr \
      --output ${screens.native} --primary --auto \
      --output ${screens.side} --off \

    ${pkgs.xorg.xrandr}/bin/xrandr \
      --output ${screens-alt.native} --primary --auto \
      --output ${screens-alt.side} --off \
  '';

  screens-2 = writeShellScriptBin "screens-2" ''
    ${pkgs.xorg.xrandr}/bin/xrandr \
      --output ${screens.native} --auto --primary \
      --output ${screens.side} --auto --right-of ${screens.native} \

    ${pkgs.xorg.xrandr}/bin/xrandr \
      --output ${screens-alt.native} --auto --primary \
      --output ${screens-alt.side} --auto --right-of ${screens-alt.native} \
  '';

  screens-mirror = writeShellScriptBin "screens-mirror" ''
    ${pkgs.xorg.xrandr}/bin/xrandr \
      --output ${screens.native} --primary --auto \
      --output ${screens.side} --same-as ${screens.native} --auto \

    ${pkgs.xorg.xrandr}/bin/xrandr \
      --output ${screens-alt.native} --primary --auto \
      --output ${screens-alt.side} --same-as ${screens-alt.native} --auto \
  '';

  screens-only-side = writeShellScriptBin "screens-only-side" ''
    ${pkgs.xorg.xrandr}/bin/xrandr \
      --output ${screens.side} --primary --auto \
      --output ${screens.native} --off \

    ${pkgs.xorg.xrandr}/bin/xrandr \
      --output ${screens-alt.side} --primary --auto \
      --output ${screens-alt.native} --off \
  '';

}

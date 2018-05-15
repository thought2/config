{ pkgs, ... }:

with import ../util;
with pkgs;

let

  screens = {
    native = "eDP-1";
    side = "DP-1";
  };

in
{
  screens-1 = with screens; writeShellScriptBin "screens-1" ''
    ${pkgs.xorg.xrandr}/bin/xrandr \
    --output ${native} --primary --auto \
    --output ${side} --off \
  '';

  screens-2 = with screens; writeShellScriptBin "screens-2" ''
    ${pkgs.xorg.xrandr}/bin/xrandr \
    --output ${native} --auto --primary \
    --output ${side} --auto --right-of ${native} \
  '';

  screens-mirror = with screens; writeShellScriptBin "screens-mirror" ''
    ${pkgs.xorg.xrandr}/bin/xrandr \
    --output ${native} --primary --auto \
    --output ${side} --same-as ${native} --auto\
  '';

}

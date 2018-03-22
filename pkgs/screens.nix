{ pkgs, ... }:

with import ../util;
with pkgs;

let

  screens = {
    native = "eDP1";
    main = "HDMI3";
    side = "DP1";
  };

in
{
  screens-1 = with screens; writeShellScriptBin "screens-1" ''
    ${pkgs.xorg.xrandr}/bin/xrandr \
    --output ${native} --primary --mode 1440x900 \
    --output ${main} --off \
    --output ${side} --off \
  '';

  screens-2 = with screens; writeShellScriptBin "screens-2" ''
    ${pkgs.xorg.xrandr}/bin/xrandr \
    --output ${native} --off \
    --output ${main} --primary --auto --right-of ${native} \
    --output ${side} --auto --right-of ${main} \
  '';

  screens-3 = with screens; writeShellScriptBin "screens-3" ''
    ${pkgs.xorg.xrandr}/bin/xrandr \
    --output ${native} --mode 1440x900 --primary \
    --output ${main} --auto --right-of ${native} \
    --output ${side} --auto --right-of ${main} \
  '';

  screens-mirror = with screens; writeShellScriptBin "screens-mirror" ''
    ${pkgs.xorg.xrandr}/bin/xrandr \
    --output ${native} --mode 1440x900 --primary \
    --output ${main} --same-as ${native} --mode 1440x900 \
    --output ${side} --off \
  '';

}

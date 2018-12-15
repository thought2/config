{ pkgs, ... }:

with pkgs;

let

  screens = {
    native = "eDP-1";
    side = "DP-1";
  };

in

{
  machine-checkout = writeShellScriptBin "machine-checkout" ''
    echo hi
  '';
}

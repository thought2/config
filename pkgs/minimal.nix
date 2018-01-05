let
  
  o = import ../overlays;
  pkgs = import (import <nixpkgs> {}).path { overlays = [ o ]; };
in

with pkgs; [
  emacs
  xmonad
]

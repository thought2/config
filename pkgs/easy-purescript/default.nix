let
  pkgs = import <nixpkgs> {};

  easyPS =
    let x = (builtins.fromJSON (builtins.readFile ./rev.json));
    in import (pkgs.fetchgit {inherit (x) url rev sha256;}) {};
in {
  inherit(easyPS.inputs)
   purs
   psc-package-simple
   purp
   spago
   ;
}

{pkgs ? import <nixpkgs> {} }:
let
  easyPS =
    let rev = (builtins.fromJSON (builtins.readFile ./rev.json));
    in import (pkgs.fetchgit {inherit (rev) url rev sha256;}) {};
in
  {
  inherit (easyPS)
    purs
    spago
    spago2nix
    purty;
}

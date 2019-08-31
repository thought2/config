{pkgs ? import <nixpkgs> {}, ...}:
with pkgs.lib;
pkgs.stdenv.mkDerivation
  { name = "BuildEnvironment";
    buildInputs = attrValues(import ../pkgs/build.nix {});
  }

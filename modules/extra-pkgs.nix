{ config, pkgs, ... }:

let
  latest =
    fetchTarball
#      https://github.com/NixOS/nixpkgs-channels/archive/0396345b79436f54920f7eb651ab42acf2eb7973.tar.gz;
      https://github.com/NixOS/nixpkgs-channels/archive/ccd53a9cb1ca4c1a2c98765010affd20ef631b86.tar.gz;


  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;

in
with pkgs;
{
  nixpkgs.config = {

    packageOverrides = pkgs: {
      latest = import latest {
        config = config.nixpkgs.config;
      };
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
      node2nixPkgs = import ../pkgs/node2nix {};
    };
  };

}

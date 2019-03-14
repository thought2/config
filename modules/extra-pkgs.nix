{ config, pkgs, ... }:

let
  latest =
    fetchTarball
#      https://github.com/NixOS/nixpkgs-channels/archive/0396345b79436f54920f7eb651ab42acf2eb7973.tar.gz;
      https://github.com/NixOS/nixpkgs-channels/archive/60e2056e47616676f5883140890464fc00dfb0b5.tar.gz;

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

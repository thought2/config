{ config, pkgs, ... }:

let
  latest =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/0396345b79436f54920f7eb651ab42acf2eb7973.tar.gz;

in
with pkgs;
{
  nixpkgs.config = {

    packageOverrides = pkgs: {
      latest = import latest {
        config = config.nixpkgs.config;
      };
    };
  };

}

{ config, pkgs, ... }:

let
  latest =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/2be930cc4a891a166ee71bc353ce9af297471e2b.tar.gz;

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

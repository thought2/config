{ config, pkgs, ... }:

let
  latestMasterRef = "b09c98b4aa2724c0f9a6ef18d5757c999918f387";

  latestMaster =
    fetchTarball
      "https://github.com/NixOS/nixpkgs-channels/archive/${latestMasterRef}.tar.gz";

in
with pkgs;
{
  nixpkgs.config = {

    packageOverrides = pkgs: {
      latestMaster = import latestMaster {
        config = config.nixpkgs.config;
      };
      node2nixPkgs = import ../pkgs/node2nix {};
    };
  };

}

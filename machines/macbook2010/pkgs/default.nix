with import <nixpkgs> {};
with import ../../../util;

let
  unpurePaths = rec {
    devConfig = "/home/mbock/dev/config/";
    pkgs = "${devConfig}/machines/macbook2010/pkgs/default.nix";
    configuration = "${devConfig}/machines/macbook2010/configuration.nix";
  };

  xm = import ../../../pkgs/xmonad {};

  basePkgs = import ../../../pkgs/base.nix;
 
  pkgs = {
  
    rebuildPkgs = writeBash {
      name = "rebuild-pkgs";
      help = "Wrapper around nix-env -rif ... Restarts XMonad afterwards.";
      src = ''
        nix-env -rif ${unpurePaths.pkgs};
        ${xm}/bin/xmonad --restart
      '';
    };

  
    rebuildMachine = writeBash {
      name = "rebuild-machine";
      help = "Wrapper around nixos-rebuild. Restarts XMonad afterwards.";
      src = ''
        export NIXOS_CONFIG=${unpurePaths.configuration}
        nixos-rebuild $@ &&
        ${xm}/bin/xmonad --restart
      '';
    };

  };

in

lib.attrValues pkgs
++ basePkgs
  


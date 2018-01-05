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
 
  pkgs = rec {
  
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

    sounds = stdenv.mkDerivation {
      name = "sounds";
      src = ../../../sounds;
      buildCommand = ''cp -r $src $out'';
    };
  

    withSound = writeBash {
      name = "with-sound";
      help = "Plays a sound after the provided executable succeeds.";  
      src = ''$1 && ${sox}/bin/play ${sounds}/thrown.mp3'';
    };

  };

in

lib.attrValues pkgs
++ basePkgs
  


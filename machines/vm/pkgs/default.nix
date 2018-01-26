with import ../../../util;

{ pkgs }:
let
  aliases = {

    hq-patch-node-bins = ''

      rm node_modules/optipng-bin/vendor/optipng
      ln -s ${bin pkgs.optipng "optipng"} node_modules/optipng-bin/vendor/optipng

      rm node_modules/pngquant-bin/vendor/pngquant
      ln -s ${bin pkgs.pngquant "pngquant"} node_modules/pngquant-bin/vendor/pngquant
      
    '';
  };
in
mkAliases aliases

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

    hq-start = withPath [ pkgs.yarn ] "yarn start";

    hq-start-beta = withPath [ pkgs.yarn ] ''
      export API_DOMAIN=hqngin-beta.hqrevenue.com
      echo $API_DOMAIN
      yarn start
    '';

    hq-start-release = withPath [ pkgs.yarn ] ''
      export API_DOMAIN=hqngin-rc.hqrevenue.com
      echo $API_DOMAIN
      yarn start
    '';

    hq-start-production = withPath [ pkgs.yarn ] ''
      export API_DOMAIN=hqngin.hqrevenue.com
      echo $API_DOMAIN
      yarn start
    '';

  };
in
mkAliases aliases

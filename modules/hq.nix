with import ../util/default.nix;

{ config, pkgs, ... }:

let
  shorthands = mkAliases {

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

    hq-browser-org = withPath [ pkgs.chromium ] ''
      chromium \
        --new-window \
        https://hqplus.slack.com/messages/ \
        https://bitbucket.org/hqreact/hq-frontend \
        https://hqplus.atlassian.net \
        https://outlook.office.com/owa/ \
    '';

    hq-browser-dev = withPath [ pkgs.chromium ] ''
      chromium \
        --new-window \
        https://localhost:8000 \
    '';

    hq-graph =
      let
        graph = pkgs.writeText "hq-graph" ''
          digraph {
            dev -> prerelease;
            prerelease -> production;
          }
        '';
        image = pkgs.runCommand "mkImage" {} ''
          ${pkgs.graphviz}/bin/dot -Tpng ${graph} -o $out
        '';
      in
        "${pkgs.feh}/bin/feh -B white -F ${image}";

  };
in
{
  imports =
    [
      ./work-station.nix
    ];

  networking.firewall.allowedTCPPorts = [ 8000 ];
  networking.firewall.enable = true;

  environment.systemPackages = shorthands;

  environment.shellAliases = {
  };

}

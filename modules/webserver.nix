{ pkgs, ... }:

with import ../util;
with builtins;
with pkgs;

let

  revisions = [
    {
      #rev = "";
      sha256 = "1pb7vljk8zdnxpk7cy8k6y2d9w102kz1ziz921pcivwbkxlfd10l";
    }
  ];

  mkOut = i: x: {
    urlPath = "/video${toString i}";
    dir = import (pkgs.fetchgit {
      url = "git://46.38.233.235:/video.git";
      sha256 = x.sha256;
    });
  };

  dirs = mapIndexed mkOut revisions;

  overview = mapIndexed (i: x: {
    urlPath = x.urlPath;
    index = i;
  }) dirs;

  sceneries = import (fetchgit {
    url = "http://github.com/thought2/sceneries";
    rev = "fe46a7d324700a773fd873b9cf0c5cc9e1d621e6";
    sha256 = "1nmlx6k5kn58zmwnbm3f3zgs47p43hy19rb5sa7sl2nbvj1gr34i";
  }) { inherit pkgs; };

  slotMachine = import (fetchgit {
    url = "https://github.com/thought2/slot-machine";
    rev = "d06d3d427e4224e319aad6bb5f15f43e27520c79";
    sha256 = "1899bsg3n2c1y32gp8g2s34jankjjy1fw2hqx3zqrbdapqah4nsd";
  }) { inherit pkgs; };

  dust = stdenv.mkDerivation {
    name = "dust";
    src = fetchgit {
      url = "https://github.com/thought2/dust.git";
      rev = "c45899e736af6eeaf7ce01d0dda06a0090fe4108";
      sha256 = "1hjvnflrzc3ipi2i2a3wwmndzi1zim99mc0n1ipjxxqrn6jncc4q";
    };

    buildCommand = ''

      dir=$(mktemp -d)

      cp -r $src/${"*"} $dir

      cd $dir

      export HOME=$(mktemp -d);

      ${elmPackages.elm}/bin/elm-package install --yes
      ${elmPackages.elm}/bin/elm-make Main.elm --yes --output main.js

      mkdir -p $out;

      mv index.html $out
      mv style.css $out
      mv main.js $out
    '';
  };

  landing = import (fetchgit {
    url = "https://github.com/thought2/landing.git";
    rev = "6af966bbdd3aad17dabb5dc3822be903c0b6ebfb";
    sha256 = "0bdvpbn898dk05k966njs1zgkd7zp1pgh02fcvxjmcc26vq5jvi7";
  }) { inherit pkgs; };

  servedDirs = [
    {
      urlPath = "/dust";
      dir = dust;
    }
    {
      urlPath = "/landing";
      dir = landing;
    }
    {
      urlPath = "/sceneries";
      dir = sceneries;
    }
    {
      urlPath = "/slot-machine";
      dir = slotMachine;
    }
    {
      urlPath = "/data";
      dir = "/srv/data";
    }
  ];

in
{
  networking.firewall.allowedTCPPorts = [ 80 9418 ];

  services.httpd = {
    enable       = true;
    adminAddr    = "me@thought2.de";

    extraConfig = ''
      <Directory /srv/data>
        Header set Access-Control-Allow-Origin "*"
      </Directory>
    '';

    servedFiles = [
      {
        urlPath = "/video";
        file = writeText "index.html" ''
          <h1>Revision Index</h1>
          ${concatStringsSep "\n" (map (x: "<a href=${x.urlPath}>Revision ${toString x.index}</a>") overview)}
        '';
      }
    ];

    documentRoot = landing;

    inherit servedDirs;
  };
}

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
    urlPath = "/video/${toString i}";
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


in
{
  networking.firewall.allowedTCPPorts = [ 80 9418 ];

  services.httpd = {
    enable       = true;
    adminAddr    = "me@thought2.de";

    servedFiles = [
      {
        urlPath = "/video";
        file = writeText "index.html" ''
          <h1>Revision Index</h1>
          ${concatStringsSep "\n" (map (x: "<a href=${x.urlPath}>Revision ${toString x.index}</a>") overview)}
        '';
      }
    ];

    servedDirs = [
      {
        urlPath = "/dust";
        dir = dust;
      }
    ] ++ dirs;
  };
}

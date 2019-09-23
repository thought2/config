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

  tuesday-coding = fetchgit {
    url = "https://github.com/thought2/tuesday-coding";
    rev = "af124df1313119cad827cf2c1ddcb5f5357138a1";
    sha256 = "0jcc6ycphfk5x7lbznala768g8mppw3rhcyr7rry7l42gmy9gxp7";
  };

  loremPicsum = stdenv.mkDerivation {
    name = "lorem-picsum";
    buildCommand = ''
      mkdir $out
      cp -r ${tuesday-coding}/2019-04-29/lorem-picsum/* -t $out
    '';
  };


  elm18 = (import (fetchTarball "https://github.com/NixOS/nixpkgs-channels/archive/94b7925b30e4b3162401791e2118dd8e45821fb4.tar.gz")
     {}).elmPackages.elm;

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

      ${elm18}/bin/elm-package install --yes
      ${elm18}/bin/elm-make Main.elm --yes --output main.js

      mkdir -p $out;

      mv index.html $out
      mv style.css $out
      mv main.js $out
    '';
  };

  blog = import (fetchgit {
        url = "https://github.com/thought2/blog.git";
        rev =  "2b11071cd8497dddd3f6da93fddce8de94db3e39";
        sha256 = "0lsi31imwpzhbcspghfh89l7yh74fz3dplzmh2p3j6lp5qkd8h8r";
      });

  projects = import (fetchGit {
    url = "git@github.com:thought2/projects";
    rev = "79e2d72f72b1591ca80bc41427518c10402c1307";

  }) { inherit pkgs; scope = "/projects"; };


  # landing = import (fetchgit {
  #   url = "https://github.com/thought2/landing.git";
  #   rev = "6af966bbdd3aad17dabb5dc3822be903c0b6ebfb";
  #   sha256 = "0bdvpbn898dk05k966njs1zgkd7zp1pgh02fcvxjmcc26vq5jvi7";
  # }) { inherit pkgs; };


  landing-purs = import (fetchgit {
    url = "https://github.com/thought2/landing-purs.git";
    rev =  "5e9947ca121c571c11d87dc085177650abb89265";
    sha256 = "1crsk540yv9qap17n95zfbl0b1i2gl9g2lk3bgpcjvpcq38mmr7i";
  }) { inherit pkgs; };

  servedDirs = [
    # {
    #  urlPath = "/dust";
    #  dir = dust;
    # }
    # {
    #   urlPath = "/landing";
    #   dir = landing;
    # }
    # {
    #   urlPath = "/sceneries";
    #   dir = sceneries;
    # }
    # {
    #   urlPath = "/slot-machine";
    #   dir = slotMachine;
    # }
    {
      urlPath = "/lorem-picsum/";
      dir = loremPicsum;
    }
    {
      urlPath = "/blog";
      dir =  blog;
    }
    { urlPath = "/projects";
      dir = projects;
    }
    {
      urlPath = "/data";
      dir = "/srv/data";
    }
    {
      urlPath = "/";
      dir = landing-purs;
    }
  ];

in
{
  networking.firewall.allowedTCPPorts = [ 80 9418 443 ];

  services.nginx.enable = true;

  services.nginx.appendHttpConfig = ''
    server_names_hash_bucket_size 64;
  '';

  services.nginx.virtualHosts."admin.localhost" = {
    addSSL = true;
    enableACME = true;
    basicAuth = { mbock = "abc"; };

    root = pkgs.runCommand "root" {} ''
      mkdir $out
      ln -s ${projects} $out/projects
    '';
  };

  services.nginx.virtualHosts."localhost" = {
    addSSL = true;
    enableACME = true;
    root = pkgs.runCommand "root" {} ''
      mkdir $out
      cp -r ${landing-purs}/* -t $out

      ln -s ${blog} $out/blog
      ln -s ${loremPicsum} $out/lorem-picsum
    '';
  };


  services.nginx.virtualHosts."stage.thought2.de" = {
    addSSL = true;
    enableACME = true;
    root = pkgs.runCommand "root" {} ''
      mkdir $out
      cp -r ${landing-purs}/* -t $out

      ln -s ${blog} $out/blog
      ln -s ${loremPicsum} $out/lorem-picsum
    '';
  };


  services.httpd = {
    enable       = false;
    adminAddr    = "me@thought2.de";

    extraConfig = ''
      <Directory /srv/data>
        Header set Access-Control-Allow-Origin "*"
      </Directory>

      <Location /projects>
        AuthName "Members Area"
        AuthType Basic
        AuthUserFile /home/mbock/.htpasswd
        require valid-user
      </Location>
    '';

    servedFiles = [
      {
        urlPath = "/video";
        file = writeText "index.html" ''
          <h1>Revision Index</h1>
          ${concatStringsSep "\n" (map (x: "<a href=${x.urlPath}>Revision ${toString x.index}</a>") overview)}
        '';
      }
      {
        urlPath = "nix.sh";
        file = writeText "nix.sh" ''
          cd $mktemp -d)
          nix-env -i git
          git clone http://github.com/thought2/nix-config
          cd nix-config
          nix-shell env/build-shell.nix
        '';
      }
    ];

    # documentRoot = landing;

    inherit servedDirs;
  };
}

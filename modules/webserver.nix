{ pkgs, ... }:

with import ../util;
with builtins;
with pkgs;

let
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

  webDirs = {
    landing = import (fetchgit {
      url = "https://github.com/thought2/landing-purs.git";
      rev =  "5e9947ca121c571c11d87dc085177650abb89265";
      sha256 = "1crsk540yv9qap17n95zfbl0b1i2gl9g2lk3bgpcjvpcq38mmr7i";
    }) { inherit pkgs; };

    blog = import (fetchgit {
      url = "https://github.com/thought2/blog.git";
      rev =  "2b11071cd8497dddd3f6da93fddce8de94db3e39";
      sha256 = "0lsi31imwpzhbcspghfh89l7yh74fz3dplzmh2p3j6lp5qkd8h8r";
    });

    projects = import (fetchGit {
      url = "git@github.com:thought2/projects";
      rev = "79e2d72f72b1591ca80bc41427518c10402c1307";
    }) { inherit pkgs; scope = "/projects"; };

    loremPicsum = stdenv.mkDerivation {
      name = "lorem-picsum";
      buildCommand = ''
        mkdir $out
        cp -r ${tuesday-coding}/2019-04-29/lorem-picsum/* -t $out
      '';
    };
  };

  locationsPublic = {
    "~ ^/blog(?:/(.*))?$" = {
      alias = webDirs.blog + "/$1";
    };
    "~ ^/landing(?:/(.*))?$" = {
      alias = webDirs.landing + "/$1";
    };
    "~ ^/lorem-picsum(?:/(.*))?$" = {
      alias = webDirs.loremPicsum + "/$1";
    };
  };

  locationsPrivate = {
    "~ ^/projects(?:/(.*))?$" = {
      alias = webDirs.projects + "/$1";
    };
  };

in
{
  networking.firewall.allowedTCPPorts = [ 80 9418 ];

  services.nginx.enable = true;

  services.nginx.appendHttpConfig = ''
    server_names_hash_bucket_size 64;
  '';

  services.nginx.virtualHosts."thought2.de" = {
    addSSL = true;
    enableACME = true;
    root = webDirs.landing;
    locations = locationsPublic;
  };

  services.nginx.virtualHosts."localhost" = {
    addSSL = true;
    enableACME = true;
    root = webDirs.landing;
    locations = locationsPublic // locationsPrivate;
  };

  services.nginx.virtualHosts."admin.localhost" = {
    addSSL = true;
    enableACME = true;
    basicAuthFile = "/etc/.htpasswd";
    root = webDirs.landing;
    locations = locationsPublic // locationsPrivate;
  };

  services.nginx.virtualHosts."stage.thought2.de" = {
    addSSL = true;
    enableACME = true;
    root = webDirs.landing;
    locations = locationsPublic // locationsPrivate;
    basicAuthFile = "/etc/.htpasswd";
  };

  services.nginx.virtualHosts."admin.thought2.de" = {
    addSSL = true;
    enableACME = true;
    root = webDirs.landing;
    locations = locationsPublic // locationsPrivate;
    basicAuthFile = "/etc/.htpasswd";
  };
}

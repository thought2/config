{ pkgs ? import <nixpkgs> {}, config ? { networking.hostName = "minimal"; }, ... }:

with pkgs;
with lib;

let
  nixosRoot = "etc/nixos";
  repoUrl = "ssh://git@github.com/thought2";
  devDir = "/home/mbock/dev";

  hosts = {
    laptop-work = {
      name = "laptop-work";
      repos = [
        {
          url = repoUrl;
          name = "nix-config";
        }
        {
          url = repoUrl;
          name = "coya-config";
        }
        {
          url = repoUrl;
          name = "private-config";
        }
      ];
    };
  };

  forEach = f: xs:
    concatStringsSep "\n" (map f xs);

  shellExpand = str: "$" + "{" + str + "}";

  indentLines = map (line: "  " + line);

  mapIndent = f: map (x: "  " + f x);

  indent = str: "  " + str;

  concatMapIndent = f: xs: map indent (concatLists (map f xs));
in

rec {
  mkdir-force = writeShellScriptBin "mkdir-force" ''
    DIR=$1
    rm -rf $DIR
    mkdir -p $DIR
  '';

  clone-and-checkout = writeShellScriptBin "clone-and-checkout" ''
    URL=$1
    REPO=$2
    BRANCH=$3
    git clone $URL/$REPO
    cd $REPO
    git checkout $BRANCH
  '';

  machine-hosts = writeShellScriptBin "machine-hosts" ''
    ${
      forEach
        (host: ''
          echo ${host.name} ${if host.name == config.networking.hostName then " *" else ""}
        '')
        (attrValues(hosts))
    }
  '';

  machine-checkout = writeShellScriptBin "machine-checkout" ''
    HOST=${shellExpand "1:-'${config.networking.hostName}'"}
    BRANCH=${shellExpand "2:-'master'"}

    ROOT=${shellExpand "ROOT:-''"}

    DIR="$ROOT/${nixosRoot}"

    alias clone-and-checkout=${clone-and-checkout}/bin/clone-and-checkout

    ${mkdir-force}/bin/mkdir-force $DIR

    cd $DIR

    case $HOST in
    ${concatStringsSep
      "\n"
      (concatMapIndent
        (host: concatLists [
          ["${host.name})"]
          (mapIndent (repo: "clone-and-checkout ${repo.url} ${repo.name} $BRANCH") host.repos)
          [(indent ";;")]
        ])
        (attrValues(hosts))
      )
    }
      *)
        exit
        ;;
    esac

    ln -s nix-config/hosts/$HOST.nix configuration.nix
  '';

  machine-checkout-workdir = writeShellScriptBin "machine-checkout-workdir" ''
    HOST=${shellExpand "1:-'${config.networking.hostName}'"}

    DIR="/${nixosRoot}"

    ${mkdir-force}/bin/mkdir-force $DIR

    cd $DIR

    cp -r ${devDir}/nix-config .
    cp -r ${devDir}/private-config .
    cp -r ${devDir}/coya-config .

    # ln -s nix-config/hosts/$HOST.nix configuration.nix
  '';
}

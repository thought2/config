{ pkgs ? import <nixpkgs> {}, config ? { networking.hostName = "minimal"; }, ... }:

with pkgs;
with lib;
with import ../util;

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
          branch = "develop";
        }
        {
          url = repoUrl;
          name = "coya-config";
          branch = "master";
        }
        {
          url = repoUrl;
          name = "private-config";
          branch = "master";
        }
      ];
    };
  };

  forEach = f: xs:
    concatStringsSep "\n" (map f xs);

  shellExpand = str: "$" + "{" + str + "}";

  indentLines =
    flow [
      (concatStringsSep "\n")
      (map indent)
      (split "\n")
      ];

  mapIndent = f: map (x: "  " + f x);

  indent = str: "  " + str;

  concatMapIndent = f: xs: map indent (concatLists (map f xs));
in

rec {
  machine-clean = writeShellScriptBin "machine-clean" ''
    ROOT=${shellExpand "1:-''"}
    DIR=$ROOT/${nixosRoot}
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
          echo '${if host.name == config.networking.hostName then "*" else " "} ${host.name}'
        '')
        (attrValues(hosts))
    }
  '';

  machine-checkout = writeShellScriptBin "machine-checkout" ''
    HOST=${shellExpand "1:-'${config.networking.hostName}'"}

    ROOT=${shellExpand "ROOT:-''"}

    DIR="$ROOT/${nixosRoot}"

    ${machine-clean}/bin/machine-clean $ROOT

    cd $DIR

    case $HOST in
    ${concatStringsSep
      "\n"
      (concatMapIndent
        (host: concatLists [
          ["${host.name})"]
          (mapIndent
             (repo: ''
               ${clone-and-checkout}/bin/clone-and-checkout ${repo.url} ${repo.name} ${repo.branch}
               echo
             ''
             )
             host.repos)
          [(indent ";;")]
        ])
        (attrValues(hosts))
      )
    }
      *)
        exit
        ;;
    esac

    ${machine-link}/bin/machine-link nix-config/hosts/$HOST.nix
  '';

  machine-link = writeShellScriptBin "machine-link" ''
    TARGET_PATH=$1
    ln -s $TARGET_PATH configuration.nix
  '';

  machine-checkout-workdir = writeShellScriptBin "machine-checkout-workdir" ''
    HOST=${shellExpand "1:-'${config.networking.hostName}'"}

    DIR="/${nixosRoot}"

    ${machine-clean}/bin/machine-clean $ROOT

    cd $DIR

    cp -r ${devDir}/nix-config .
    cp -r ${devDir}/private-config .
    cp -r ${devDir}/coya-config .

    ${machine-link}/bin/machine-link nix-config/hosts/$HOST.nix
  '';
}

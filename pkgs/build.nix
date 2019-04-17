{ pkgs ? import <nixpkgs> {}
, config ? { networking.hostName = "minimal-uefi"; }
, ...
}:

with pkgs;
with lib;
with import ../util;

let
  nixosRoot = "etc/nixos";
  repoUrl = "ssh://git@github.com/thought2";
  devDir = "~/dev";

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
    desktop = {
      name = "desktop";
      ip = {
        local = "192.168.178.28";
      };
      repos = [
        {
          url = "http://github.com/thought2";
          name = "nix-config";
          branch = "develop";
        }
        {
          url = repoUrl;
          name = "private-config";
          branch = "master";
        }
      ];
    };
    laptop = {
      name = "laptop";
      ip = {
        local = "192.168.178.33";
      };
      repos = [
        {
          url = repoUrl;
          name = "nix-config";
          branch = "develop";
        }
        {
          url = repoUrl;
          name = "private-config";
          branch = "master";
        }
      ];
    };
    prod = {
      name = "prod";
      repos = [
        {
          url = repoUrl;
          name = "nix-config";
          branch = "master";
        }
      ];
    };
    stage = {
      name = "stage";
      repos = [
        {
          url = repoUrl;
          name = "nix-config";
          branch = "develop";
        }
      ];
    };
    minimal-uefi = {
      name = "minimal-uefi";
      repos = [
        {
          url = "http://github.com/thought2";
          name = "nix-config";
          branch = "develop";
        }
      ];
    };
    minimal-legacy = {
      name = "minimal-legacy";
      repos = [
        {
          url = "http://github.com/thought2";
          name = "nix-config";
          branch = "develop";
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

    export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
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

  # @TODO: make accept cmd args
  # maybe make recognize if install-cd or not (ROOT=/mnt or none)
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
             ''
             )
             host.repos)
          [(indent ";;")]
        ])
        (attrValues(hosts))
      )
    }
      *)
        echo "Unknown host."
        exit
        ;;
    esac

    nixos-generate-config \
      --force \
      `[ "$ROOT" ] && echo "--root $ROOT"`

    ${machine-link}/bin/machine-link nix-config/hosts/$HOST.nix
  '';

  machine-link = writeShellScriptBin "machine-link" ''
    TARGET_PATH=$1
    rm configuration.nix
    ln -s $TARGET_PATH configuration.nix
  '';

  machine-checkout-workdir = writeShellScriptBin "machine-checkout-workdir" ''
    HOST=${shellExpand "1:-'${config.networking.hostName}'"}
    DEV_DIR=$2
    ROOT=${shellExpand "ROOT:-''"}
    DIR="/${nixosRoot}"

    ${machine-clean}/bin/machine-clean $ROOT

    cd $DIR

    cp -r $DEV_DIR/nix-config .
    cp -r $DEV_DIR/private-config .
    cp -r $DEV_DIR/coya-config .

    # @TODO: check root here
    nixos-generate-config --force # --root $ROOT

    ${machine-link}/bin/machine-link nix-config/hosts/$HOST.nix
  '';

  partition-machine = writeShellScriptBin "partition-machine" ''
    FORCE=false

    # PARSE ARGS

    OPTS=`getopt -o f --long force -- "$@"`

    [ $? -eq 0 ] || exit 1

    eval set -- "$OPTS"

    while true ; do
      case "$1" in
        -f|--force)
          FORCE=true
          shift
          ;;
        --)
          shift
          break
          ;;
        *)
          exit 1
          ;;
      esac
    done


    # CONFIRM

    if [ "$FORCE" = false ]
    then
      read -p "Are you sure? (yes/no)"
      if [ "$REPLY" != "yes" ]
      then
        exit 1
      fi
    fi


    # MAIN

    echo good

  '';

  # write-iso-to-device =
  # let
  #   isoMinimal32 = fetchurl {
  #       url = "https://d3g5gsiof5omrk.cloudfront.net/nixos/18.09/nixos-18.09.1676.7e88992a8c7/nixos-minimal-18.09.1676.7e88992a8c7-i686-linux.iso";
  #       sha256 = "0p9vz87xg72f7agq51mwy6x8fi2x03xm5psv61vf5pf1sspaidn4";
  #     };
  # in
  # writeShellScriptBin "write-iso-to-device" ''
  #   DEVICE="/dev/disk/by-id/usb-SanDisk_Ultra_4C530001190720103262-0:0"
  #   dd status=progress if="${isoMinimal32}" of="$DEVICE"
  # '';

  partition-uefi =
    writeShellScriptBin "partition-uefi"
      ''
        DEVICE=""
        FORCE=false

        TEMP=`getopt -o "" -l force:,device: -- "$@"`
        eval set -- "$TEMP"

        while true ; do
            case "$1" in
                --force) FORCE=$2 ; shift 2 ;;
                --device) DEVICE=$2 ; shift 2 ;;
                --) shift ; break ;;
                *) echo "Internal error!" ; exit 1 ;;
            esac
        done

        [ "$DEVICE" = "" ] && echo "no device given." && exit 1;

        # CONFIRM

        if [ "$FORCE" = false ]
        then
          read -p "Are you sure to destroy \"$DEVICE\"? (yes/no) "
          if [ "$REPLY" != "yes" ]
          then
            exit 1
          fi
        fi


        # MAIN

        ${pkgs.parted}/bin/parted --script -- $DEVICE mklabel gpt
        ${pkgs.parted}/bin/parted --script -- $DEVICE mkpart primary 512MiB -0
        ${pkgs.parted}/bin/parted --script -- $DEVICE mkpart ESP fat32 1MiB 512MiB
        ${pkgs.parted}/bin/parted --script -- $DEVICE set 2 boot on

        ${e2fsprogs}/bin/mkfs.ext4 -FL nixos "$DEVICE"*1
        ${dosfstools}/bin/mkfs.fat -F 32 -n boot "$DEVICE"*2

        mount /dev/disk/by-label/nixos /mnt

        mkdir -p /mnt/boot
        mount /dev/disk/by-label/boot /mnt/boot
      '';

  # @TODO refactor as the uefi one!
  partition-legacy = writeShellScriptBin "partition-legacy" ''
    DEVICE=/dev/sda
    FORCE=false


    # PARSE ARGS

    OPTS=`getopt -o f --long force -- "$@"`

    [ $? -eq 0 ] || exit 1

    eval set -- "$OPTS"

    while true ; do
      case "$1" in
        -f|--force)
          FORCE=true
          shift
          ;;
        --)
          shift
          break
          ;;
        *)
          exit 1
          ;;
      esac
    done


    # CONFIRM

    if [ "$FORCE" = false ]
    then
      read -p "Are you sure to destroy \"$DEVICE\"? (yes/no) "
      if [ "$REPLY" != "yes" ]
      then
        exit 1
      fi
    fi


    # MAIN

    ${pkgs.parted}/bin/parted --script $DEVICE -- mklabel msdos
    ${pkgs.parted}/bin/parted --script $DEVICE -- mkpart primary 1MiB -0

    ${e2fsprogs}/bin/mkfs.ext4 -FL nixos /dev/sda1

    mount /dev/disk/by-label/nixos /mnt
  '';

}

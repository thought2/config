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
   desktop = {
      name = "desktop";
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
    laptop = {
      name = "laptop";
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

  write-iso-to-device =
  let
    isoMinimal32 = fetchurl {
        url = "https://d3g5gsiof5omrk.cloudfront.net/nixos/18.09/nixos-18.09.1676.7e88992a8c7/nixos-minimal-18.09.1676.7e88992a8c7-i686-linux.iso";
        sha256 = "0p9vz87xg72f7agq51mwy6x8fi2x03xm5psv61vf5pf1sspaidn4";
      };
  in
  writeShellScriptBin "write-iso-to-device" ''
    DEVICE="/dev/disk/by-id/usb-SanDisk_Ultra_4C530001190720103262-0:0"
    dd status=progress if="${isoMinimal32}" of="$DEVICE"
  '';

  partition-uefi = writeShellScriptBin "partition-uefi" ''
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
      read -p "Are you sure to destroy \"$DEVICE\"? (yes/no)"
      if [ "$REPLY" != "yes" ]
      then
        exit 1
      fi
    fi


    # MAIN

    alias parted="${pkgs.parted}/bin/parted --script $DEVICE"

    parted -- mklabel gpt
    parted -- mkpart primary 512MiB -0GiB
    parted -- mkpart ESP fat32 1MiB 512MiB
    parted -- set 3 boot on

    ${e2fsprogs}/bin/mkfs.ext4 -L nixos "$DEVICE"1
    ${e2fsprogs}/bin/mkfs.fat -F 32 -n boot "$DEVICE"2

    mount /dev/disk/by-label/nixos /mnt

    mkdir -p /mnt/boot
    mount /dev/disk/by-label/boot /mnt/boot

    nixos-generate-config --root /mnt
  '';

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
      read -p "Are you sure to destroy \"$DEVICE\"? (yes/no)"
      if [ "$REPLY" != "yes" ]
      then
        exit 1
      fi
    fi


    # MAIN

    alias parted="${pkgs.parted}/bin/parted --script $DEVICE"

    parted -- mklabel msdos
    parted -- mkpart primary 1MiB -0GiB

    ${e2fsprogs}/bin/mkfs.ext4 -L nixos /dev/sda1

    mount /dev/disk/by-label/nixos /mnt

    nixos-generate-config --root /mnt
  '';
}

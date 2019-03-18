{ pkgs ? import <nixpkgs> {}, config, ... }:

with pkgs;
with import ../util;
with import ../util/trivial-builders.nix { inherit pkgs; };

import ./screens.nix {inherit pkgs;} // import ./build.nix {inherit pkgs config; }  //
rec {

  tmp = writeShellScriptBin "tmp" ''
    COUNT_DAYS_AGO=${shellExpand "1:-'0'"}
    DATE_STR=`date +%Y-%m-%d_%V-%a -d "$COUNT_DAYS_AGO days ago"`
    echo ~/tmp/$DATE_STR
  '';

  # elm-find-doc-modules = buildPureScriptBin {
  #     name = "elm-find-doc-modules";
  #     src = ./shorthands/ps;
  #     main = "ElmTooling.FindDocumentedModules";
  #   };

  elm-json-as-package = writeTypeScript "elm-json-as-package" {
      dependencies = {
        "@types/node" = "^11.11.0";
        "@types/yargs" = "^12.0.9";
        "yargs" = "^13.2.2";
      };
    }
    (pkgs.lib.readFile ./shorthands/ts/src/elm-json-as-package.ts);

  elm-doc-preview-local = writeShellScriptBin "elm-doc-preview-local" ''
    EXPOSED_MODULES=$1
    shift
    SRC_DIR=`pwd`/$1
    shift
    SEP=$1
    shift

    TMP=`mktemp -d`

    ${elm-json-as-package}/bin/elm-json-as-package \
      --output $TMP/elm.json \
      --exposedModules $EXPOSED_MODULES

    cd $TMP
    ln -s $SRC_DIR src

    ${pkgs.node2nixPkgs.elm-doc-preview}/bin/elm-doc-preview $@
  '';

  chrome-set-search-engines =
    let
      executable = writeTypeScript "executable" {
        dependencies = {
          "@types/node" = "^11.11.0";
          "@types/yargs" = "^12.0.9";
          "yargs" = "^13.2.2";
        };
      }
      (pkgs.lib.readFile ./shorthands/ts/src/chrome-set-search-engines.ts);
    in
      writeShellScriptBin "chrome-set-search-engines" ''
        ${executable}/bin/executable \
          --data-file ${./shorthands/search-engines.json} \
          --sqliteCmd ${pkgs.sqlite}/bin/sqlite3
      '';

  hotreload = writeShellScriptBin "hotreload" ''
    DIR=$1
    CMD=$2
    while ${inotify-tools}/bin/inotifywait -e modify $DIR; do eval $CMD; done
  '';

  news = writeShellScriptBin "news" ''
    ${pkgs.chromium}/bin/chromium --new-window \
      'https://elm-news.com/' \
      'https://news.ycombinator.com' \
  '';

  nix-shell-elm19 = writeShellScriptBin "nix-shell-elm19" ''
    nix-shell -E 'with import (fetchTarball "https://github.com/NixOS/nixpkgs-channels/archive/0396345b79436f54920f7eb651ab42acf2eb7973.tar.gz") { }; runCommand "elm-env" { buildInputs = [ elmPackages.elm ]; } ""'
  '';

  # elm-make = writeShellScriptBin "elm-make" ''
  #   ${elmPackages.elm}/bin/elm-make $@
  # '';

  # elm-reactor = writeShellScriptBin "elm-reactor" ''
  #   ${elmPackages.elm}/bin/elm-reactor $@
  # '';

  github-repos = writeShellScriptBin "github-repos" ''
    USER=$1
    USER=${shellExpand "USER:-'thought2'"}
    curl -s https://api.github.com/users/$USER/repos | ${pkgs.jq}/bin/jq '.[]|.name'
  '';

  github-clone = writeShellScriptBin "github-clone" ''
    USER=$1
    REPO=$2
    shift 2
    USER=${shellExpand "USER:-'thought2'"}
    ${pkgs.git}/bin/git clone git@github.com:$USER/$REPO.git $@
  '';

  bower-install = writeShellScriptBin "bower-install" ''
    PKG=$1
    shift
    ARGS=$@

    [ -d bower_components ] || exit 1;

    ${nodePackages.bower}/bin/bower info $PKG |
    grep -e '  - [0-9]\+\.[0-9]\+\.[0-9]\+' |
    sed 's/^  - //' |
    while read -r VERSION
    do
      echo $'\cc' | ${nodePackages.bower}/bin/bower install $ARGS $PKG'#^'$VERSION
      [ -d "bower_components/$PKG" ] && break
    done
  '';

  show-keyboard =
    let
      image = fetchurl {
        url = "https://n1.sdlcdn.com/imgs/c/n/k/KB216_1-7fd1d.jpg";
        sha256 = "1x3yabdicjj2474nd8kxvgdjsvy5rbq0fswn9nxaan5g2js7wj9p";
      };
      image-cropped = runCommand "crop-it" {} ''
        ${pkgs.imagemagick}/bin/convert ${image} -shave 100x450 $out
      '';
    in
      writeShellScriptBin "show-keyboard" ''
        ${pkgs.feh}/bin/feh -. -B white ${image-cropped}
      '';

  toggle-touchpad = writeShellScriptBin "toggle-touchpad" ''
    ID=$(${pkgs.xorg.xinput}/bin/xinput --list | grep Touchpad | sed 's/^.*id=\([0-9]\+\).*$/\1/' | head -n 1);
    N=$(${pkgs.xorg.xinput}/bin/xinput --list-props $ID | grep "Device Enabled" | sed 's/.*\([01]\).*$/\1/' | head -n 1);
    NEW_N=$(if [ $N == "1" ]; then echo 0; else echo 1; fi);
    ${pkgs.xorg.xinput}/bin/xinput set-int-prop $ID "Device Enabled" 8 $NEW_N
  '';

  n = writeShellScriptBin "n" ''
    nixos-rebuild switch $@
  '';

  n-t = writeShellScriptBin "n-t" ''
    nixos-rebuild test $@
  '';

  emacs2 = writeShellScriptBin "emacs2" ''
    ${pkgs.emacs}/bin/emacs $@
  '';

  chromium-org = writeShellScriptBin "chromium-org" ''
    ${pkgs.chromium}/bin/chromium --new-window \
    https://www.servercontrolpanel.de/SCP/Login#keep \
    https://functionalprogramming.slack.com/#keep \
    https://webchat.freenode.net/#keep \
    http://taz.de/#keep \
    https://news.ycombinator.com/#keep \
    https://stackoverflow.com/#keep \
  '';

  deploy-config = writeShellScriptBin "deploy-config" ''
    export NIXOS_CONFIG=$1
    TARGET_HOST=$2
    nixos-rebuild switch --target-host "$TARGET_HOST" --build-host localhost
  '';

  deploy-data = writeShellScriptBin "deploy-data" ''
    FROM=$1
    TO=$2
    ${pkgs.rsync}/bin/rsync \

      --archive --verbose --compress --partial --progress --delete "$FROM" "$TO"
  '';

  keyboard-de = writeShellScriptBin "keyboard-de" ''
    ${pkgs.xorg.setxkbmap}/bin/setxkbmap de -variant mac
    ${pkgs.xorg.xmodmap}/bin/xmodmap /etc/Xmodmap
  '';

  keyboard-us = writeShellScriptBin "keyboard-us" ''
    ${pkgs.xorg.setxkbmap}/bin/setxkbmap us -variant mac
    ${pkgs.xorg.xmodmap}/bin/xmodmap /etc/Xmodmap
  '';

  youtube-dl-mp3 = writeShellScriptBin "youtube-dl-mp3" ''
      ${pkgs.youtube-dl}/bin/youtube-dl \
      --extract-audio \
      --audio-format mp3 \
      --output "%(playlist_index)s_%(title)s.%(ext)s" \
      $1
    '';

  backlight = writeShellScriptBin "backlight" ''
    echo -n $1 > /sys/class/backlight/acpi_video0/brightness
  '';

  # nix-search = writeShellScriptBin "nix-search" ''
  #   nix-env -qa --description -P '.*'$1'.*' | cat
  # '';

  curl-dl = writeShellScriptBin "curl-dl" ''
    ${pkgs.curl}/bin/curl -LkO $1
  '';

  chrome-debug = writeShellScriptBin "chrome-debug" ''
    ${pkgs.chromium}/bin/chromium --remote-debugging-port=9222
  '';

  chrome = writeShellScriptBin "chrome" ''
    ${pkgs.chromium}/bin/chromium $@
  '';

  chrome-browser = writeShellScriptBin "chrome-browser" ''
    ${pkgs.chromium}/bin/chromium $@
  '';

  which-ls = writeShellScriptBin "which-ls" ''
    ${pkgs.coreutils}/bin/ls -laR $(${pkgs.which}/bin/which $1)
  '';

  test-webserver = writeShellScriptBin "test-webserver" ''
    set -e

    PROTOCOL=${"\${PROTOCOL:-http}"}
    PORT=${"\${PORT:-80}"}
    HOST=${"\${HOST:-localhost}"}

    function isOK {
      URL_PATH=$1
      URL=$PROTOCOL://$HOST:$PORT/$URL_PATH
      echo "testing $URL"
      STATUS=$(${pkgs.curl}/bin/curl -kso /dev/null -Lw "%{http_code}" $URL)
      echo $STATUS
      [ $STATUS -eq 200 ]
    }

    isOK dust
    isOK video
    isOK video0
  '';

  fdisk-disks = writeShellScriptBin "fdisk-disks" ''
    ${pkgs.eject}/bin/fdisk -l | ${pkgs.gnugrep}/bin/grep "^Disk"
  '';

  notify-play =
    let
      soundFile = pkgs.fetchurl
        { url = "https://notificationsounds.com/notification-sounds/plucky-550/download/mp3";
          name = "plucky.mp3";
          sha256 = "0qvg85zvlx5dcp4fbngpqa4ml3nd62lyyldhnwb00i1q1w4p82cp";
        };
    in
      writeShellScriptBin "notify-play" ''
        ${pkgs.sox}/bin/play -t mp3 ${soundFile}
      '';

  patch-elm-binaries = with pkgs.elmPackages; writeShellScriptBin "patch-elm-binaries" ''
      DIR=./node_modules/elm/Elm-Platform/0.18.0/.cabal-sandbox/bin
      rm $DIR/elm; ln -s ${elm}/bin/elm $DIR/elm
      rm $DIR/elm-make; ln -s ${elm}/bin/elm-make $DIR/elm-make
      rm $DIR/elm-package; ln -s ${elm}/bin/elm-package $DIR/elm-package
      rm $DIR/elm-reactor; ln -s ${elm}/bin/elm-reactor $DIR/elm-reactor
      rm $DIR/elm-repl; ln -s ${elm}/bin/elm-repl $DIR/elm-repl
      rm ./node_modules/elm-format/unpacked_bin/elm-format; ln -s ${elm}/bin/elm-format ./node_modules/elm-format/unpacked_bin/elm-format

      DIR=./node_modules/elm-test/bin
      rm $DIR/elm-interface-to-json; ln -s ${elm-interface-to-json}/bin/elm-interface-to-json $DIR/elm-interface-to-json
    '';

  byzanz-left = writeShellScriptBin "byzanz-left" ''
      ${pkgs.byzanz}/bin/byzanz-record -x 0 -y 0 -w 1920 -h 1080 $@
    '';

  webserver = writeShellScriptBin "webserver" ''
      ${pkgs.python}/bin/python –m http.server $1
    '';
}

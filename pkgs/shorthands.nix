{ pkgs, ... }:

with pkgs;

import ./screens.nix {inherit pkgs;} //
{
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

  nix-search = writeShellScriptBin "nix-search" ''
    nix-env -qa --description -P '.*'$1'.*' | cat
  '';

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

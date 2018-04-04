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

  nix-search = writeShellScriptBin "nix-search" ''
    nix-env -qa --description -P '.*'$1'.*' | cat
  '';

  curl-dl = writeShellScriptBin "curl-dl" ''
    ${pkgs.curl}/bin/curl -LkO $1
  '';

  chrome-debug = writeShellScriptBin "chrome-debug" ''
    ${pkgs.chromium}/bin/chromium --remote-debugging-port=9222
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

  test-buildvms = writeShellScriptBin "test-buildvms" ''
    CONFIG_DIR=${./..};
    ${readFile ../test/machines.sh}
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
}

with import ../util;
with import <nixpkgs> {};
with lib;

{ config, ... }:
self: super: {

  emacs-client = let
    # FIXME: implement without roundtrip
    # initFile = builtins.toFile "init.el" (builtins.readFile ../emacs/default.el);
    # eval = ''(load-file "${initFile}")'';
  in writeBash {
    name = "emacs-client";
    src = ''${self.emacs}/bin/emacsclient --create-frame'';
  };

  xmonad = import ./xmonad { pkgs = self; inherit config; };

  shorthands = mapAttrs writeShellScriptBin {

    chrome-debug = "${super.chromium}/bin/chromium --remote-debugging-port=9222";

    youtube-dl-mp3 = ''
      ${self.youtube-dl}/bin/youtube-dl --extract-audio \
                                        --audio-format mp3 \
                                        --output "%(title)s.%(ext)s" \
                                        $@
      '';

    test-buildvms = ''
      CONFIG_DIR=${./..};
      ${readFile ../test/machines.sh}
    '';

    which-ls = withPath [self.which self.coreutils]
      ''ls -laR $(which $1)'';

    fdisk-disks = withPath [self.eject self.gnugrep]
      ''fdisk -l | grep "^Disk"'';

    curl-dl = withPath [self.curl]
      "curl -LkO $1";

    nixos-test = withPath [self.xmonad]
      "nixos-rebuild test && xmonad --restart";

    nixos-switch = withPath [self.xmonad]
      "nixos-rebuild switch && xmonad --restart";

    nix-search = "nix-env -qa --description -P '.*'$1'.*' | cat";

    test-webserver = withPath [self.curl] ''
      set -e

      PROTOCOL=${"\${PROTOCOL:-http}"}
      PORT=${"\${PORT:-80}"}
      HOST=${"\${HOST:-localhost}"}

      function isOK {
        URL_PATH=$1
        URL=$PROTOCOL://$HOST:$PORT/$URL_PATH
        echo "testing $URL"
        STATUS=$(curl -kso /dev/null -Lw "%{http_code}" $URL)
        echo $STATUS
        [ $STATUS -eq 200 ]
      }

      isOK dust
      isOK video
      isOK video0
    '';
  };

}

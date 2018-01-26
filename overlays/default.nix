with import ../util;
with import <nixpkgs> {};
with lib;

self: super: {
  emacs = import ./emacs { pkgs = self; };

  emacs-client = let
    # FIXME: implement without roundtrip
    # initFile = builtins.toFile "init.el" (builtins.readFile ../emacs/default.el);
    # eval = ''(load-file "${initFile}")'';
  in writeBash {
    name = "emacs-client";
    src = ''${self.emacs}/bin/emacsclient --create-frame'';
  };

  xmonad = import ./xmonad { pkgs = self; };

  notify-play =
    let
      soundFile = super.fetchurl {
        url = "https://notificationsounds.com/notification-sounds/plucky-550/download/mp3";
        name = "plucky.mp3";
        sha256 = "0qvg85zvlx5dcp4fbngpqa4ml3nd62lyyldhnwb00i1q1w4p82cp";
      };
    in
    writeBash {
      name = "notify-play";
      help = "Plays a notification sound.";
      src = ''
        ${super.sox}/bin/play -t mp3 ${soundFile}
      '';
    };

  shorthands = mapAttrs writeShellScriptBin {

    chrome-debug = "${super.chromium}/bin/chromium --remote-debugging-port=9222";

    keyboard-de = "${self.xorg.setxkbmap}/bin/setxkbmap de -variant mac";

    keyboard-us = "${self.xorg.setxkbmap}/bin/setxkbmap us -variant mac";

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

  };

}

with import ../util;

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
}

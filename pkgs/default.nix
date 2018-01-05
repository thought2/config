with import <nixpkgs> {};

let

  pkgs =  import <nixpkgs> {};

  bashInitFile = ''

  '';

  aliases = {
    emacs = "${emacs'}/bin/emacs --no-splash";
    emacs-vanilla = "${emacs}/bin/emacs";
    bash = "${bash}/bin/bash --init-file ${bashInitFile}";
  };
 
in []

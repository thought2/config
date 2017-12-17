{ isMac }:

with import <nixpkgs> {};

let

  pkgs =  import <nixpkgs> {};

  emacs = if isMac then emacsMacport else emacs;
    
  more = (pkgs.emacsPackagesNgGen emacs).trivialBuild {
    pname = "my-mode";
    src = ./default.el;
  };

  emacs' = pkgs.emacsWithPackages (epkgs: with epkgs; [
    #elm-oracle
    aggressive-indent
    auto-complete
    better-defaults
    cider
    clojure-mode
    company
    company
    elm-mode
    flycheck
    flycheck-elm
    #melpaPackages.nix-mode
    mmm-mode
    more
    paredit
    smartparens
    tide
    web-mode
  ]);

  mkAlias = name: command: writeScriptBin name ''
    #!${bash}/bin/bash
    ${command} "$@"
  '';

  bashInitFile = ''

  '';

  aliases = {
#    emacs = "${emacs'}/bin/emacs --no-splash";
#    emacs-vanilla = "${emacs}/bin/emacs";
    bash = "${bash}/bin/bash --init-file ${bashInitFile}";
  };
  
  aliaspkgs = builtins.attrValues (lib.mapAttrs mkAlias aliases);

in [
  aliaspkgs
  emacs'
] ++ (with elmPackages; [
  elm
]) ++ (with nodePackages; [
  node2nix
])

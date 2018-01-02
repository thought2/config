{ pkgs ? import <nixpkgs> {}, isMac ? false }:

let
  defaultEl = ./default.el;

  emacsConfig = pkgs.runCommand "default.el" {} ''
    mkdir -p $out/share/emacs/site-lisp
    cp ${defaultEl} $out/share/emacs/site-lisp/default.el
  '';

  myEmacs = if isMac
    then pkgs.emacsMacport
    else pkgs.emacs25;

  emacsWithPackages = (pkgs.emacsPackagesNgGen myEmacs).emacsWithPackages;

in
  emacsWithPackages (epkgs: with epkgs; [
    emacsConfig
    aggressive-indent
    auto-complete
    better-defaults
    cider
    clojure-mode
    helm-dash
    company
    elm-mode
    flycheck
    flycheck-elm
    #melpaPackages.nix-mode
    mmm-mode
    magit
    paredit
    smartparens
    tide
    web-mode
    direx
    haskell-mode
    nixos-options
    helm-nixos-options
    company-nixos-options
    nix-sandbox
])

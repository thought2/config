{ pkgs ? import <nixpkgs> {}, isMac ? false }:

let
  
  mkEmacsConfig = emacs: configFile: pkgs.runCommand "default.el" {} ''

    #validate
    ${emacs}/bin/emacs --batch -l ${configFile}

    #make
    mkdir -p $out/share/emacs/site-lisp
    cp ${configFile} $out/share/emacs/site-lisp/default.el

  '';

  baseEmacs = if isMac
    then pkgs.emacsMacport
    else pkgs.emacs25;

  buildEmacs = emacs: g: (pkgs.emacsPackagesNgGen emacs).emacsWithPackages g;

  emacsWithForeignPackages = buildEmacs baseEmacs (epkgs: with epkgs; [
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
    melpaPackages.nix-mode
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
    js2-mode
    prettier-js
    indium
    yasnippet
    elfeed
  ]);

in

  buildEmacs emacsWithForeignPackages (x: [
    (mkEmacsConfig emacsWithForeignPackages ./default.el)
  ] ++ (if isMac then [
    (mkEmacsConfig emacsWithForeignPackages ./mac-default.el)
  ] else []))

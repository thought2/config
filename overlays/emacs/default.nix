{ pkgs ? import <nixpkgs> {}, isMac ? false }:

let
  
  mkEmacsConfig = configFile: pkgs.runCommand "default.el" {} ''
    mkdir -p $out/share/emacs/site-lisp
    cp ${configFile} $out/share/emacs/site-lisp/default.el
  '';

  emacsConfig = mkEmacsConfig ./default.el;

  emacsConfigMac = mkEmacsConfig ./mac-default.el;

  myEmacs = if isMac
    then pkgs.emacsMacport
    else pkgs.emacs25;

  emacsWithPackages = (pkgs.emacsPackagesNgGen myEmacs).emacsWithPackages;

in
  emacsWithPackages (epkgs: with epkgs; [
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
    emacsConfig
] ++ (if isMac then [emacsConfigMac] else []))

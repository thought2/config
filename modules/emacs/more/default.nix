{ pkgs, lib, ... }:

with lib;
with pkgs.emacs25PackagesNg;

{
  programs.emacs.stanzas.more =
    { epkgs = flatten
      [ hydra
        aggressive-indent
        auto-complete
        better-defaults
        cider
        clojure-mode
        helm-dash
        company
        flycheck
        melpaPackages.nix-mode
        mmm-mode
        paredit
        smartparens
        tide
        web-mode
        direx
        [haskell-mode hindent]
        nixos-options
        helm-nixos-options
        company-nixos-options
        nix-sandbox
        js2-mode
        prettier-js
        indium
        yasnippet
        elfeed
        [ ensime sbt-mode ] # scala
        [ ivy-pass helm-pass pass ]
        dictcc
      ];
      init = readFile ./default.el;
    };
}

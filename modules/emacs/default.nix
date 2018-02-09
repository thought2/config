{ config, lib, pkgs, ... }:
with lib;
let

  isMac = false;

  mkEmacsConfig = emacs: configFile: pkgs.runCommand "default.el" {} ''

    # validate
    ${emacs}/bin/emacs --batch -l ${configFile}

    # make
    mkdir -p $out/share/emacs/site-lisp
    cp ${configFile} $out/share/emacs/site-lisp/default.el

  '';

  baseEmacs = if isMac
    then pkgs.emacsMacport
    else pkgs.emacs25;

  buildEmacs = emacs: g: (pkgs.emacsPackagesNgGen emacs).emacsWithPackages g;

  foreignPkgs = (epkgs: with epkgs; [
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

  emacsWithForeignPackages = buildEmacs baseEmacs foreignPkgs;

  baseInitFile = readFile ./default.el;

  initFile = (pkgs.writeText "default.el" (baseInitFile + config.programs.emacs.init));

  emacs = buildEmacs baseEmacs (epkgs: (foreignPkgs epkgs) ++ [
    (mkEmacsConfig emacsWithForeignPackages initFile)
  ] ++ (if isMac then [
    (mkEmacsConfig emacsWithForeignPackages ./mac-default.el)
  ] else []));

  overlay = self: super: {
    inherit emacs;
  };
in
{
  options.programs.emacs.init = mkOption {
    type = types.string;
    default = "";
  };

  config.nixpkgs.overlays = [overlay];
}

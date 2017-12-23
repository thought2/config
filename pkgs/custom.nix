with import <nixpkgs> {};
rec {

  more = pkgs.emacsPackagesNg.trivialBuild {
    pname = "my-mode";
    src = ./emacs/default.el;
  };

  emacs' = pkgs.emacsWithPackages (epkgs: with epkgs; [
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
    magit
    more
    paredit
    smartparens
    tide
    web-mode
    direx
  ]);

}

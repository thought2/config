self: super: {
  emacs =
    let
      more = self.emacsPackagesNg.trivialBuild {
        pname = "my-mode";
        src = ../emacs/default.el;
      };
    in
      self.emacsWithPackages (epkgs: with epkgs; [
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
      more
      paredit
      smartparens
      tide
      web-mode
      direx
      haskell-mode
    ]);

  xmonad = import ../xmonad { pkgs = self; };
}

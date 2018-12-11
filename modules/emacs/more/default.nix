{ pkgs, lib, ... }:

with lib;
with pkgs.emacs25PackagesNg;

{
  programs.emacs.stanzas.more =
    { epkgs = flatten
      [ yaml-mode
        hydra
        aggressive-indent
        auto-complete
        better-defaults
        purescript-mode
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
        [ yasnippet yasnippet-snippets ]
        elfeed
        [ ensime sbt-mode ] # scala
        [ ivy-pass helm-pass pass ]
        dictcc
        avy
        json-mode
        restclient
        # browse-kill-ring
        helm
        [ helm-swoop swiper-helm ]
        highlight-indentation
        scratch-palette
        helm-mode-manager
        # backward-forward
        better-shell
        buffer-move
        duplicate-thing
        # dynamic-spaces
        zenburn-theme
        disable-mouse
        darkroom
        immortal-scratch
        persistent-scratch
        melpaPackages.use-package
        multiple-cursors
        [ glsl-mode company-glsl ]
        helm-company
        yafolding
        whitespace-cleanup-mode
        [ psc-ide psci ]
        rust-mode
        flycheck-rust
        toml-mode
        undo-tree
        magithub
        magit-find-file
        magit-gh-pulls
        expand-region
        shell-here
        dired-narrow
      ];
      init = readFile ./default.el;
    };
}

{ pkgs ? import <nixpkgs>, config, ... }:

with pkgs;
with import ../../util;

let
  shorthands = import ../../pkgs/shorthands.nix { inherit pkgs config; };

  baseEmacs = pkgs.emacs25;

  init = mkEmacsPackage ./el;

  customEmacs = (pkgs.emacsPackagesNgGen baseEmacs).emacsWithPackages (epkgs:
    with epkgs;
    [
      init
    ] ++ lib.flatten [
        dim
        fill-column-indicator
        yaml-mode
        hydra
        aggressive-indent
        auto-complete
        better-defaults
        # purescript-mode
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
        # magithub
        # magit-find-file
        # magit-gh-pulls
        expand-region
        shell-here
        dired-narrow
        move-text
        dhall-mode
        tuareg # ocaml
        helm-projectile
        [ magit magit-gitflow ]
        hydra
        [
          flycheck
          # elm-mode
          # flycheck-elm
          smartparens
        ]
        async
        dash
        shell-switcher
        helm-ag
        neotree
        dashboard
        # reformatter
      ]
  );

  generatedEl = ''

(setq bookmark-default-file "${./bookmarks}")

(progn
  (setq cmd-screens-1 "${shorthands.screens-1}/bin/screens-1")
  (setq cmd-screens-2 "${shorthands.screens-2}/bin/screens-2")
  (setq cmd-screens-mirror "${shorthands.screens-mirror}/bin/screens-mirror")
  (setq cmd-keyboard-de "${shorthands.keyboard-de}/bin/keyboard-de")
  (setq cmd-keyboard-us "${shorthands.keyboard-us}/bin/keyboard-us"))


    (global-set-key (kbd "C-x g") 'magit-status)
    (global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
    (global-set-key (kbd "C-c C-c p") 'find-file-at-point)

    (global-set-key (kbd "C-z") 'avy-goto-line-above)
    (global-set-key (kbd "C-`") 'avy-goto-line-below)
    (global-set-key (kbd "C-c g") 'helm-grep-do-git-grep)
    (global-set-key (kbd "<backtab>") 'company-complete)
    (global-set-key (kbd "C-c C-p") 'scratch-palette-popup)


    (global-set-key '[8711] #'hydra-main/body)


    (defvar my-keys-minor-mode-map
       (let ((map (make-sparse-keymap)))
;;         (define-key map (kbd "C-z") 'ace-jump-line-mode)
           (define-key map (kbd "C-.") 'avy-goto-char-timer)
         (define-key map (kbd "C-c c") #'comment-or-uncomment-region)
         map)
       "my-keys-minor-mode keymap.")

    (define-minor-mode my-keys-minor-mode
      "A minor mode so that my key settings override annoying major modes."
      :init-value t
      :lighter " my-keys")

    (my-keys-minor-mode 1)

  '';

  mkEmacsPackage = src: runCommand "default" {} ''
    mkdir -p $out/share/emacs/site-lisp
    cp -r ${src}/${"*"} $out/share/emacs/site-lisp/
    cp ${writeText "generated.el" generatedEl} $out/share/emacs/site-lisp/generated.el
  '';

  overlay = self: super: {
    emacs = writeShellScriptBin "emacs" ''
      cd ${init}/share/emacs/site-lisp # god knows, why this is necessary
      ${customEmacs}/bin/emacs $@
    '';
  };

in

{
  config.nixpkgs.overlays = [ overlay ];
}

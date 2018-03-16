{ config, lib, pkgs, ... }:
with lib;
with import ../../util;
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

  foreignPkgs = (epkgs: config.programs.emacs.pkgs);

  emacsWithForeignPackages = buildEmacs baseEmacs foreignPkgs;

  initFile =
    let
      text =
        config.programs.emacs.init;
    in
      pkgs.writeText "default.el" text;

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

  options.programs.emacs.pkgs = mkOption {
    type = types.listOf types.package;
    default = [];
  };

  config.nixpkgs.overlays = [overlay];

  imports = with pkgs.emacs25PackagesNg;
    [ ( let
          uuid = "77f23723-5e67-4156-bf1b-22daeaa29581";
          path = "/tmp/${uuid}";
        in
        { programs.emacs.init = ''
            (setq init-file "${path}")

            (defun reload-init ()
              (interactive)
              (load-file init-file))
          '';
          system.activationScripts.initEmacs = ''
            cp ${initFile} "${path}"
          '';
        }
      )
      { programs.emacs =
        { pkgs = [ magit magit-gitflow ];
          init = ''
          (with-eval-after-load 'magit
            (require 'magit-gitflow)
            (add-hook 'magit-mode-hook 'turn-on-magit-gitflow))
          '';
        };
      }
      { programs.emacs =
        { pkgs = [ hydra ];
          init = ''
            (require 'hydra)

            (defhydra hydra-screens nil
              "screens"
              ("1" (shell-command "${pkgs.screens-1}/bin/screens-1") "1" :exit t)
              ("2" (shell-command "${pkgs.screens-2}/bin/screens-2") "2" :exit t)
              ("3" (shell-command "${pkgs.screens-3}/bin/screens-3") "3" :exit t)
              )

            (defhydra hydra-keyboard nil
              "keyboard"
              ("d" (shell-command "${pkgs.keyboard-de}/bin/keyboard-de") "de" :exit t)
              ("u" (shell-command "${pkgs.keyboard-us}/bin/keyboard-us") "us" :exit t)
              )


            (defhydra hydra-main nil
              "main"
              ("s" hydra-screens/body "screens" :exit t)
              ("k" hydra-keyboard/body "keyboard" :exit t)
              )

            (global-set-key '[8711] #'hydra-main/body)
          '';
        };
      }
      { programs.emacs =
        { pkgs = flatten
          [ aggressive-indent
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
            [ ensime sbt-mode ] # scala
            [ ivy-pass helm-pass pass ]

          ];
          init = readFile ./default.el;
        };
      }
    ];
}

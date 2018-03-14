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
            [ ivy-pass helm-pass pass ]

          ];
          init = readFile ./default.el;
        };
      }
    ];
}

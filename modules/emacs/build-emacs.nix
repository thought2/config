{ config, lib, pkgs, ... }:
with lib;
with pkgs;
with import ../../util;
let

  cfg = config.programs.emacs;

  baseEmacs = pkgs.emacs25;

  mkEmacsConfig = eepkgs: init:
    let
      emacs' = buildEmacs baseEmacs eepkgs;
      initFile = writeText "default-propose.el" init;
    in
      runCommand "default.el" {} ''
      
        # validate
        ${emacs'}/bin/emacs --batch -l ${initFile}

        # make
        mkdir -p $out/share/emacs/site-lisp
        cp ${initFile} $out/share/emacs/site-lisp/default.el

      '';

  buildEmacs = emacs: epkgs:
    (pkgs.emacsPackagesNgGen emacs).emacsWithPackages (X: epkgs);

  emacs = buildEmacs baseEmacs (cfg.pkgs ++ [
    (mkEmacsConfig cfg.pkgs cfg.init )
  ]);

  # emacs3 =
  #   let
  #     deps = concatMap ({ pkgs, ...}: pkgs) cfg.stanzas;
  #     epkgs = map mkEmacsConfig cfg.stanzas;
  #   in
  #     buildEmacs baseEmacs (deps ++ epkgs);
  
  overlay = self: super: {
    emacs = pkgs.writeShellScriptBin "emacs" "${emacs}/bin/emacs --no-splash $@";
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

  options.programs.emacs.stanzas = mkOption {
    default = [];
  };

  config.nixpkgs.overlays = [overlay];

}

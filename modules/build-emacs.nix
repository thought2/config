{ config, lib, pkgs, ... }:

with lib;
with pkgs;
with import ../util;

let

  cfg = config.programs.emacs;

  baseEmacs = pkgs.emacs25;

  buildEmacs = emacs: epkgs:
    (pkgs.emacsPackagesNgGen emacs).emacsWithPackages (_: epkgs);

  mkEmacsPackage = { name, epkgs, init }:
    let
      emacs' = buildEmacs baseEmacs epkgs;
      initFile = writeText "${name}-default.el" init;
    in
      runCommand name {} ''

        # validate
        echo "validating ${name}"
        ${emacs'}/bin/emacs --batch -f package-initialize -l ${initFile}

        # make
        mkdir -p $out/share/emacs/site-lisp
        cp ${initFile} $out/share/emacs/site-lisp/default.el

      '';

  emacs =
    let
      stanzasList =
        mapAttrsToList (name: value: value // { inherit name; }) cfg.stanzas;
      deps = concatMap ({ epkgs, ...}: epkgs) stanzasList;
      epkgs = map mkEmacsPackage stanzasList;
      fullInit =
        cfg.init + (concatStringsSep "\n" (map ({init, ...}: init) stanzasList));
      customPkg =
        mkEmacsPackage { name = "custom"; epkgs = deps; init = fullInit; };
    in
      # epkgs only appended to circumvent laziness
      buildEmacs baseEmacs (deps ++ [ customPkg ] ++ epkgs);

  emacsWrapped = pkgs.writeShellScriptBin
    "emacs"
    "${emacs}/bin/emacs --no-splash $@";

  overlay = self: super: {
    emacs = emacsWrapped;
  };

in

{

  options.programs.emacs.stanzas = mkOption {
    default = {};
  };


  options.programs.emacs.init = mkOption {
    default = "";
  };


  config.nixpkgs.overlays = [ overlay ];

  config.environment.systemPackages = [ emacsWrapped ];
}

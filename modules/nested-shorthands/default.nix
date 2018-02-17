{ config, lib, pkgs, ... }:

with lib;
with builtins;

let

  cfg = config.nested-shorthands;

  getName = path: k: concatStringsSep "-" (path ++ [k]);

  #@TODO: maybe better work with symlinks here
  wrap = name: pkg: pkgs.writeShellScriptBin name ''
    ${pkg}/bin/${"*"}
  '';

  getPaths = path: xs:
    let
      f = { name, pkg ? null, children ? null, ... }:
        if pkg != null then
          [ (wrap (getName path name) pkg) ]
        else if children != null then
          (getPaths (path ++ [name]) children)
        else
          [];
    in
      concatLists (map f xs);


in

{
  options.nested-shorthands = mkOption {
    default = [];
  };

  config.environment.systemPackages = getPaths [] cfg;

  config.programs.emacs = {
    init =
      let
        data = pkgs.writeText "data.json" (toJSON cfg);
      in
        ''
          (require 'hydra)
          ${readFile ./default.el}
          (generate-hydra:main '("hydra" "gen") "${data}")
          (global-set-key (kbd "C-c C-f") #'hydra-gen/body)
        '';
    pkgs = [ pkgs.emacs25PackagesNg.hydra ];
  };
}

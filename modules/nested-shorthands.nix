{ config, lib, pkgs, ... }:

with lib;
with builtins;

let

  getName = path: k: concatStringsSep "-" (path ++ [k]);

  #@TODO: maybe better work with symlinks here
  wrap = name: pkg: pkgs.writeShellScriptBin name ''
    ${pkg}/bin/${"*"}
  '';

  getPaths = path: xs:
    let
      f = { name, pkg, children, ... }:
        if pkg != false then
          [ (wrap (getName path name) pkg) ]
        else if children != false then
          (getPaths (path ++ [name]) children)
        else
          [];
    in
      concatLists (map f xs);


in

{
  options.nested-shorthands = mkOption {
    default = [];
    type = with types;
      let

        item = submodule
          { options =
            { pkg = mkOption
                { type = (either package bool);
                  default = false;
                };
              children = mkOption
                { type = (either forest bool);
                  default = false;
                };
              name = mkOption
                { type = str;
                };
              kbd = mkOption
                { type = str;
                };
            };
          };

        forest = listOf item;
      in forest;
  };

  config.environment.systemPackages = getPaths [] config.nested-shorthands;
}

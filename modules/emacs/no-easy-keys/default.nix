{ pkgs, lib, ... }:

with lib;
with pkgs.emacs25PackagesNg;

{
  programs.emacs.stanzas.no-easy-keys =
    { epkgs = flatten
      [ ];
      init = readFile ./default.el;
    };
}

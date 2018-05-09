{ pkgs, ... }:

with pkgs;
with builtins;

let
  shorthands = import ../../../pkgs/shorthands.nix { inherit pkgs; };
  screens = import ../../../pkgs/screens.nix { inherit pkgs; };
in

{
  programs.emacs.stanzas.hydra.epkgs = with pkgs.emacs25PackagesNg;
    [ hydra ];

  programs.emacs.stanzas.hydra.init = with shorthands; with screens;''

    (setq cmd-screens-1 "${screens-1}/bin/screens-1")
    (setq cmd-screens-2 "${screens-2}/bin/screens-2")
    (setq cmd-screens-mirror "${screens-mirror}/bin/screens-mirror")
    (setq cmd-keyboard-de "${keyboard-de}/bin/keyboard-de")
    (setq cmd-keyboard-us "${keyboard-us}/bin/keyboard-us")

  ''
  + readFile ./default.el;
}

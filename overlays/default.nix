with import ../util;
with import <nixpkgs> {};
with lib;

{ config, ... }:
self: super: {

  emacs-client = writeShellScriptBin "emacs-client" ''
    ${pkgs.emacs}/bin/emacsclient --create-frame
  '';

  xmonad = import ./xmonad { pkgs = self; inherit config; };

  pythonExt = self.python3Packages.python.withPackages (p: [ p.notebook p.grip ]);
}

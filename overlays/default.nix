with import ../util;
with import <nixpkgs> {};
with lib;

{ config, ... }:
self: super: {

  emacs-client = let
    lispExpr = ''
      (progn
        (shell (concat "shell-" (car (split-string (shell-command-to-string "uuidgen")))))
        (delete-other-windows))
    '';
  in
    writeShellScriptBin "emacs-client" ''
      ${pkgs.emacs}/bin/emacsclient --create-frame -e '${lispExpr}'
    '';

  xmonad = import ./xmonad { pkgs = self; inherit config; };

  pythonExt = self.python3Packages.python.withPackages (p: [ p.notebook p.grip ]);
}

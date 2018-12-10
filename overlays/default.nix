self: super:
let
  node2nixPkgs = import ../pkgs/node2nix {};
in
{
  chalk = node2nixPkgs.chalk-cli;

  emacs-client = let
    lispExpr = ''
      (progn
        (shell (concat "shell-" (car (split-string (shell-command-to-string "uuidgen")))))
        (delete-other-windows))
    '';
  in
    super.writeShellScriptBin "emacs-client" ''
      ${super.emacs}/bin/emacsclient --create-frame -e '${lispExpr}'
    '';

  xmonad = import ./xmonad { pkgs = self; };

  pythonExt = self.python3Packages.python.withPackages (p: [ p.notebook p.grip ]);
}

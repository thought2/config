{ pkgs, initText }:

with pkgs.emacs25PackagesNg;

let
  uuid = "77f23723-5e67-4156-bf1b-22daeaa29581";
  path = "/tmp/${uuid}";
  initFile = pkgs.writeText "default.el" initText;
in

{
  programs.emacs.init = ''
    (setq init-file "${path}")

    (defun reload-init ()
      (interactive)
      (load-file init-file))
  '';

  system.activationScripts.initEmacs = ''
    cp ${initFile} "${path}"
  '';

}

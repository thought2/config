{ pkgs, config, ... }:

with pkgs.emacs25PackagesNg;

let
  initFile = config.programs.emacs.init;
  uuid = "77f23723-5e67-4156-bf1b-22daeaa29581";
  path = "/tmp/${uuid}";
in

{ imports = [ ./build-emacs.nix ];


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

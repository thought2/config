{ pkgs, ... }:

with pkgs.emacs25PackagesNg;

{ 
  programs.emacs.stanzas.hydra =
    { epkgs = [ hydra ];
      init = ''

        (setq cmd-screens-1 "${pkgs.screens-1}/bin/screens-1")

        (require 'hydra)

	(defhydra hydra-screens nil
	  "screens"
	  ("1" (shell-command cmd-screens-1) "1" :exit t)
	  ("2" (shell-command "${pkgs.screens-2}/bin/screens-2") "2" :exit t)
	  ("3" (shell-command "${pkgs.screens-3}/bin/screens-3") "3" :exit t)
	  )

	(defhydra hydra-keyboard nil
	  "keyboard"
	  ("d" (shell-command "${pkgs.keyboard-de}/bin/keyboard-de") "de" :exit t)
	  ("u" (shell-command "${pkgs.keyboard-us}/bin/keyboard-us") "us" :exit t)
	  )


	(defhydra hydra-zoom nil
	  "zoom"
	  ("+" text-scale-increase "in")
          ("-" text-scale-decrease "out")
	  )

	(defhydra hydra-main nil
	  "main"
	  ("s" hydra-screens/body "screens" :exit t)
	  ("k" hydra-keyboard/body "keyboard" :exit t)
          ("z" hydra-zoom/body "zoom" :exit t)
	  )

	(global-set-key '[8711] #'hydra-main/body)

      '';
    }
  ;
}

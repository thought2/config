(require 'hydra)

(defhydra hydra-screens nil
  "screens"
  ("1" (shell-command cmd-screens-1) "1" :exit t)
  ("2" (shell-command cmd-screens-2) "2" :exit t)
  ("3" (shell-command cmd-screens-3) "3" :exit t)
  ("m" (shell-command cmd-screens-mirror) "mirror" :exit t))

(defhydra hydra-keyboard nil
  "keyboard"
  ("d" (shell-command cmd-keyboard-de) "de" :exit t)
  ("u" (shell-command cmd-keyboard-us) "us" :exit t))

(defhydra hydra-zoom nil
  "zoom"
  ("+" text-scale-increase "in")
  ("-" text-scale-decrease "out"))

(defhydra hydra-find nil
  "find"
  ("f" find-file-at-point "find-file-at-point" :exit t))

(defhydra hydra-git nil
  "git"
  ("b" magit-blame "magit-blame" :exit t))

(defhydra hydra-main nil
  "main"
  ("s" hydra-screens/body "screens" :exit t)
  ("f" hydra-find/body "find" :exit t)
  ("k" hydra-keyboard/body "keyboard" :exit t)
  ("g" hydra-git/body "git" :exit t)
  ("z" hydra-zoom/body "zoom" :exit t)
  ("l" hydra-fontlock/body "fontlock" :exit t))

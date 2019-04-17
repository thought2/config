;;; default.el --- Emacs Configuration

;; Copyright (C) 2017 by Michael Bock

;; Author: Michael Bock <me@thought2.de>

;;{{{ GPL

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;}}}

;;; Commentary:

;; A work-in-progress Emacs configuration File.


;;; Code:


(progn
  ;; Packages
  (require 'package)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
  (package-initialize))


(load-file "./magit-config.el")
(load-file "./generated.el")


(progn
  ;; make Emacs look less noisy.

  (setq inhibit-splash-screen t)
  (setq inhibit-startup-screen t)
  (setq inhibit-startup-message t)
  (setq initial-scratch-message "")
  (setq inhibit-startup-echo-area-message "m")
  (blink-cursor-mode 0)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

(progn
  (when (display-graphic-p)
    (fringe-mode 4)

    (set-fringe-mode 8)

    (define-fringe-bitmap 'right-curly-arrow
      [#b00000000
       #b00000000
       #b00000000
       #b00000000
       #b01110000
       #b00010000
       #b00010000
       #b00000000])

    (define-fringe-bitmap 'left-curly-arrow
      [#b00000000
       #b00000000
       #b00000000
       #b00000000
       #b00000000
       #b00000000
       #b00000000
       #b00000000])))

(progn
  ;; general editing functionality.
  (global-set-key (kbd "C-c C-r") #'replace-string))


(progn
  ;;Buffer configuration.
  (global-set-key (kbd "C-c n") #'rename-buffer)
  (global-set-key (kbd "C-c u") #'rename-uniquely))


(progn
  ;; Elisp
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
  (add-hook 'emacs-lisp-mode-hook #'eldoc-mode)
  (add-hook 'emacs-lisp-mode-hook #'auto-complete-mode)
  (add-hook 'emacs-lisp-mode-hook #'company-mode))

;; (use-package emacs-lisp-mode
;;  :hook (emacs-lisp-mode . (aggressive-indent-mode paredit-mode))
;;  )

(progn
  ;; Cider
  (add-hook 'cider-mode-hook #'aggressive-indent-mode)
  (add-hook 'cider-mode-hook #'paredit-mode)
  (add-hook 'cider-mode-hook #'eldoc-mode)
  (add-hook 'cider-mode-hook #'auto-complete-mode)
  (add-hook 'cider-mode-hook #'company-mode)

  (add-hook 'cider-repl-mode-hook #'aggressive-indent-mode)
  (add-hook 'cider-repl-mode-hook #'paredit-mode)
  (add-hook 'cider-repl-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'auto-complete-mode)
  (add-hook 'cider-repl-mode-hook #'company-mode))


(progn
  ;; Clojure
  (add-hook 'clojure-mode-hook #'aggressive-indent-mode)
  (add-hook 'clojure-mode-hook #'paredit-mode)
  (add-hook 'clojure-mode-hook #'eldoc-mode)
  (add-hook 'clojure-mode-hook #'auto-complete-mode)
  (add-hook 'clojure-mode-hook #'company-mode))


(progn
  ;; clojureScript
  (add-hook 'clojure-script-mode-hook #'aggressive-indent-mode)
  (add-hook 'clojure-script-mode-hook #'paredit-mode)
  (add-hook 'clojure-script-mode-hook #'eldoc-mode)
  (add-hook 'clojure-script-mode-hook #'auto-complete-mode)
  (add-hook 'clojure-script-mode-hook #'company-mode))


(progn
  ;; Startup
  (shell))


(progn
  ;; Shell
  (global-set-key (kbd "C-c s") 'shell))


(progn
  ;; Windows

  (defun set-buffer-width-per10 (step-w_)
    (interactive "PX of 10? ")
    (let* ((step-w (or step-w_ 7))
           (max-steps 10)
           (display-width (nth 3 (assq 'geometry (car (display-monitor-attributes-list))))))
      (window-resize nil
                     (- (* step-w (round (/ display-width max-steps)))
                        (window-width nil 'pixelwise))
                     t
                     nil
                     'pixelwise)))

  (defun set-buffer-height-per10 (step-h_)
    (interactive "PX of 10? ")
    (let* ((max-steps 10)
           (step-h (or step-h_ 7)))
      (window-resize nil
                     (- (* step-h (round (/ (x-display-pixel-height) max-steps)))
                        (window-body-height nil 'pixelwise))
                     nil
                     nil
                     'pixelwise)))

  (windmove-default-keybindings)

  (global-set-key (kbd "C-c h") #'set-buffer-height-per10)
  (global-set-key (kbd "C-c w") #'set-buffer-width-per10))


(progn
  ;; Typography

  (set-frame-font "DejaVu Sans Mono")
  (set-face-attribute 'default nil :height 79))


(progn
  ;; Language
  (setq lexical-binding t))


(progn
  ;; Minibuffer
  (add-hook 'eval-expression-minibuffer-setup-hook #'paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'show-paren-mode))


(progn
  ;; Typescript

  (require 'yasnippet)
  (yas--define-parents 'web-mode '(js-mode))

  (defun setup-tide-mode ()
    (interactive)
    (tide-setup)
    (flycheck-mode +1)
    (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (eldoc-mode +1)
    (tide-hl-identifier-mode +1)
    (company-mode +1)

    ;; aligns annotation to the right hand side
    (setq company-tooltip-align-annotations t))

  ;; formats the buffer before saving
  ;;(add-hook 'before-save-hook 'tide-format-before-save)

  (add-hook 'typescript-mode-hook #'setup-tide-mode)

  (defun tsx ()
    (require 'web-mode)
    (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.ts\\'" . web-mode))
    (add-hook 'web-mode-hook
              (lambda ()
                (when (and buffer-file-name
                           (or (string-equal "tsx" (file-name-extension buffer-file-name))
                               (string-equal "ts" (file-name-extension buffer-file-name))))
                  (setup-tide-mode))))

    ;; enable typescript-tslint checker

    (require 'flycheck)
    (flycheck-add-mode 'typescript-tslint 'web-mode))


  (defun jsx ()
    (require 'web-mode)
    (add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
    (add-hook 'web-mode-hook
              (lambda ()
                (when (and buffer-file-name ;; might be nil
                           (string-equal "jsx" (file-name-extension buffer-file-name)))
                  (setup-tide-mode))))
    ;; configure jsx-tide checker to run after your default jsx checker
    (flycheck-add-mode 'javascript-eslint 'web-mode)
    ;;(flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)
    )

  ;;

  (tsx)
  (jsx)

  ;;(setq sp-base-key-bindings 'smartparens)
  ;;(add-hook 'typescript-mode-hook #'smartparens-mode)
  ;; TODO: check inconsistency below: ' vs #'
  ;; (add-hook 'before-save-hook 'tide-format-before-save)
  (add-hook 'typescript-mode-hook #'setup-tide-mode))

(progn
  ;;;  camelCase-mode.el --- minor mode for editing with camelCase words
  ;;   Copyright (C) 2001  C.R.Manning
  ;;
  ;; This program is free software; you can redistribute it and/or modify
  ;; it under the terms of the GNU General Public License as published by
  ;; the Free Software Foundation; either version 2 of the License, or
  ;; (at your option) any later version.
  ;;
  ;; This program is distributed in the hope that it will be useful,
  ;; but WITHOUT ANY WARRANTY; without even the implied warranty of
  ;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ;; GNU General Public License for more details.
  ;;
  ;; You should have received a copy of the GNU General Public License
  ;; along with this program; if not, write to the Free Software
  ;; Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

;;; History:

  ;; Author: C.R.Manning caroma@ai.mit.edu
  ;;         at http://www.ai.mit.edu/people/caroma/tools/
  ;; Created: 19 May 2001
  ;; last update: 20 May 2001
  ;; Keywords: camelCase camel case word mode
  ;; Tested on: Gnu Emacs 20.7, XEmacs 21.4

;;; Installation

  ;; Suggested GNU Emacs .emacs (or XEmacs .xemacs/init.el) initialization:
  ;;   (autoload 'camelCase-mode "camelCase-mode" nil t)
  ;;   (add-hook 'java-mode-hook '(lambda () (camelCase-mode 1)))
  ;; more global hooks:  find-file-hooks, post-command-hook

;;; Description:

  ;; camelCase-mode is a Gnu Emacs minor mode which modifies the Emacs
  ;; forward-word, backward-word, delete-word, etc. keystroke-commands
  ;; so they also work on words within a <i>camelCase</i> identifier.
  ;; As a minor mode, camelCase-mode can be used within any other
  ;; editing mode --- Java-mode, text mode, etc.  No functionality is
  ;; lost, since the forward s-expression, backward s-expression,
  ;; delete s-expression, etc. commands are still available to navigate
  ;; over entire camelCase names.
  ;;
  ;; Word boundaries in a camelCase name are marked only by letter case.
  ;; For example lowerCapitalUPPERCase has four words.  A word may be
  ;; lowercase, Capitalized, UPPERCASE, or a sequence of digits.  Besides
  ;; non-letter to letter and letter to non-letter word boundaries,
  ;; word boundaries in the middle of a sequence of letters are located at
  ;; lowercaseCapital, CapitalCapital, lowercaseUPPERCASE,
  ;; CapitalUPPERCASE, and UPPERCASECapital boundaries.
  ;;
  ;; Rebound keys:
  ;;   M-f, M-right, C-right   camelCase-forward-word
  ;;   M-b, M-left,  C-left    camelCase-backward-word
  ;;   M-d,                    camelCase-forward-kill-word
  ;;   M-backspace,  C-delete  camelCase-backward-kill-word
  ;;   M-t                     camelCase-transpose-words
  ;;   M-c                     camelCase-capitalize-word
  ;;   M-u                     camelCase-upcase-word
  ;;   M-l                     camelCase-downcase-word
  ;;
  ;; camelCase-mode prefix arg: 0 turns off, 1 turns on, nil toggles mode.

;;; Subtleties

  ;; Handles uppercase acronyms within camelCase words.  For example
  ;;   "URLConnection" is like "URL-Connection", not "URLC-onnection"

;;; Limitations

  ;; Does not affect other Emacs functions which operate on words,
  ;;   such as dabbrev-mode
  ;; M-t transpose-words does not change case of words.  For example:
  ;;   - transposing "fooBar" produces "Barfoo", not "barFoo".
  ;;   - transposing "fooBAR" produces "BARfoo", not "BARFoo".
  ;;   - transposing "fooBar baz" at space produces "foobaz Bar" not "fooBaz bar"
  ;;   When this is an issue, capitalize words before transposing them,
  ;;   e.g., M-b M-c M-t for the first two examples, or M-c M-b M-t for
  ;;   the last one.

;;; Code:

;;; MODE:

  (defvar camelCase-modeline-indicator " camelCase"
    "call (camelCase-install-mode) again if this is changed")
  (defvar camelCase-mode nil)
  (make-variable-buffer-local 'camelCase-mode)
  (put 'camelCase-mode 'permanent-local t)

  (defun camelCase-mode (&optional arg)
    "Minor mode which overrides word command keys for editing camelCase words.

 Word boundaries in a camelCase name are marked only by letter case.
 For example lowerCapitalUPPERCase has four words.  A word may be
 lowercase, Capitalized, UPPERCASE, or a sequence of digits.  Besides
 non-letter to letter and letter to non-letter word boundaries,
 word boundaries in the middle of a sequence of letters are located at
 lowercaseCapital, CapitalCapital, lowercaseUPPERCASE,
 CapitalUPPERCASE, and UPPERCASECapital boundaries.

 Rebound keys:
   M-f, M-right*,  C-right      camelCase-forward-word
   M-b, M-left*,   C-left       camelCase-backward-word
   M-d, M-delete*, C-delete*    camelCase-forward-kill-word
   M-backspace,    C-backspace* camelCase-backward-kill-word
   M-t                          camelCase-transpose-words
   M-c                          camelCase-capitalize-word
   M-u                          camelCase-upcase-word
   M-l                          camelCase-downcase-word
 (* means only in Gnu Emacs, not in XEMacs; the original binding is not
  to the word command in XEmacs, so it is not overridden)

 camelCase-mode prefix ARG:  0 turns off, 1 turns on, nil toggles mode."
    (interactive "P")
    (setq camelCase-mode
          (if (null arg) (not camelCase-mode)
            (> (prefix-numeric-value arg) 0)))
    (force-mode-line-update))

  (defconst camelCase-keybindings-list
    (cond ((memq 'xemacs features) ;; xemacs uses different key syntax
           '(
             ("\M-f"              camelCase-forward-word)
             ("\M-b"              camelCase-backward-word)
             ("\M-d"              camelCase-forward-kill-word)
             ("\M-DEL"            camelCase-backward-kill-word)
             ("\M-t"              camelCase-transpose-words)
             ("\M-c"              camelCase-capitalize-word)
             ("\M-u"              camelCase-upcase-word)
             ("\M-l"              camelCase-downcase-word)
                                        ;((meta right)        camelCase-forward-word) ;
                                        ;((meta left)         camelCase-backward-word)
                                        ;((meta delete)       camelCase-forward-kill-word)
             ((meta backspace)    camelCase-backward-kill-word)
             ((control right)     camelCase-forward-word)
             ((control left)      camelCase-backward-word)
                                        ;((control delete)    camelCase-forward-kill-word)
                                        ;((control backspace) camelCase-backward-kill-word)
             ))
          (t ;; assume recent gnu emacs (e.g., 20.7)
           '(
             ("\M-f"         camelCase-forward-word)
             ("\M-b"         camelCase-backward-word)
             ("\M-d"         camelCase-forward-kill-word)
             ("\M-DEL"       camelCase-backward-kill-word)
             ("\M-t"         camelCase-transpose-words)
             ("\M-c"         camelCase-capitalize-word)
             ("\M-u"         camelCase-upcase-word)
             ("\M-l"         camelCase-downcase-word)
             ([\M-right]     camelCase-forward-word)
             ([\M-left]      camelCase-backward-word)
             ([\M-backspace] camelCase-backward-kill-word)
             ([\M-delete]    camelCase-forward-kill-word)
             ([\C-right]     camelCase-forward-word)
             ([\C-left]      camelCase-backward-word)
             ([\C-delete]    camelCase-forward-kill-word)
             ([\C-backspace] camelCase-backward-kill-word)
             ))
          ))

  (defconst camelCase-mode-map
    (let ((map (make-sparse-keymap)))
      (mapcar (lambda (binding)
                (define-key map (cl-first binding) (cl-second binding)))
              camelCase-keybindings-list)
      (fset 'camelCase-mode-map map)
      map)
    "keymap for camelCase minor mode.")

  ;; install the minor mode
  (defun camelCase-add-minor-mode (mode-toggle-variable-name
                                   modeline-indicator-string mode-map)
    (let ((old-mode-entry (assq mode-toggle-variable-name minor-mode-alist)))
      (setq minor-mode-alist
            (cons (list mode-toggle-variable-name modeline-indicator-string)
                  (delq old-mode-entry minor-mode-alist))))
    (let ((old-map-entry (assq mode-toggle-variable-name
                               minor-mode-map-alist)))
      (setq minor-mode-map-alist
            (cons (cons mode-toggle-variable-name mode-map)
                  (delq old-map-entry minor-mode-map-alist)))))


  (defun camelCase-install-mode ()
    ;; call function without causing byte-compiler warning if other not defined
    (let ((add-minor-mode-fn (if (and (memq 'xemacs features)
                                      (fboundp 'add-minor-mode))
                                 'add-minor-mode
                               'camelCase-add-minor-mode)))
      (funcall add-minor-mode-fn
               'camelCase-mode
               camelCase-modeline-indicator
               camelCase-mode-map)))

  (camelCase-install-mode)

;;; COMMANDS:

  (defconst camelCase-regexp "\\([A-Z]?[a-z]+\\|[A-Z]+\\|[0-9]+\\)"
    ;; capital must be before uppercase
    "regular expression that matches a camelCase word, defined as
Capitalized, lowercase, or UPPERCASE sequence of letters,
or sequence of digits.")

  (defun camelCase-forward-word (count)
    "move point foward COUNT camelCase words"
    (interactive "p")
    ;; search forward increments point until some match occurs;
    ;; extent of match is as large as possible at that point.
    ;; point is left at END of match.
    (if (< count 0)
        (camelCase-backward-word (- count))
      (let ((old-case-fold-search case-fold-search)
            (case-fold-search nil)) ;; search case sensitively
        (unwind-protect
            (when (re-search-forward camelCase-regexp nil t count)
              ;; something matched, just check for special case.
              ;; If uppercase acronym is in camelCase word as in "URLNext",
              ;; search will leave point after N rather than after L.
              ;; So if match starting back one char doesn't end same place,
              ;; then back-up one char.
              (when (save-excursion
                      (let ((search-end (point)))
                        (forward-char -1)
                        (and (looking-at camelCase-regexp)
                             (not (= search-end (match-end 0))))))
                (forward-char -1))
              (point))
          (setq case-fold-search old-case-fold-search)))))

  (defun camelCase-backward-word (count)
    "move point backward COUNT camelCase words"
    (interactive "p")
    ;; search backward decrements point until some match occurs;
    ;; extent of match is as large as possible at that point.
    ;; So once point is found, have to keep decrementing point until we cross
    ;; into another word, which changes the match end.
    ;; for multiple words, have to do whole thing COUNT times.
    (if (< count 0)
        (camelCase-forward-word (- count))
      (let ((start-position (point))
            (old-case-fold-search case-fold-search)
            (case-fold-search nil)) ;; search case-sensitively
        (unwind-protect
            (while (< 0 count)
              (setq count (1- count))
              (let ((start (point)))
                (when (re-search-backward camelCase-regexp nil t)
                  (let ((end-word (match-end 0)))
                    (forward-char -1)
                    (while (save-excursion
                             ;;like looking-at, but stop match at start
                             (let ((position (point)))
                               (re-search-forward camelCase-regexp start t)
                               (and (= position (match-beginning 0))
                                    (= end-word (match-end 0)))))
                      (forward-char -1))
                    (forward-char 1)))))
          (setq case-fold-search old-case-fold-search))
        (if (= start-position (point)) nil (point)))))

  (defun camelCase-forward-kill-word (count)
    "kill text between current point and end of next camelCase word"
    (interactive "*p")
    (kill-region (point) (progn (camelCase-forward-word count) (point))))
  (defun camelCase-backward-kill-word (count)
    "kill text between current point and end of previous camelCase word"
    (interactive "*p")
    (kill-region (point) (progn (camelCase-backward-word count) (point))))
  (defun camelCase-transpose-words (count)
    "transpose camelCase words around point, leaving point afterward.
With prefix arg COUNT, moves word before point past COUNT words
forward or backward.  If COUNT is 0, exchanges word around pont
with word around mark."
    (interactive "*p")
    (transpose-subr 'camelCase-forward-word count))
  (defun camelCase-capitalize-word (count)
    "Capitalize word starting at point, leaving point after word."
    (interactive "*p")
    (let ((start (point)))
      (camelCase-forward-word count)
      (capitalize-region start (point))))
  (defun camelCase-upcase-word (count)
    "Make word starting at point UPPERCASE, leaving point after word."
    (interactive "*p")
    (let ((start (point)))
      (camelCase-forward-word count)
      (upcase-region start (point))))
  (defun camelCase-downcase-word (count)
    "Make word starting at point lowercase, leaving point after word."
    (interactive "*p")
    (let ((start (point)))
      (camelCase-forward-word count)
      (downcase-region start (point))))


  (provide 'camelCase))

(progn
  ;; Direx
  (global-set-key (kbd "C-x C-j") 'direx:jump-to-directory))


(progn
  ;; Spelling

  ;; enable spell checking for comments in all programming modes
  (add-hook 'prog-mode-hook #'flyspell-prog-mode)
  (add-hook 'text-mode-hook #'flyspell-mode)

  ;; FIXME: get impure path from nix configuration.
  ;;(setq ispell-personal-dictionary "/home/mbock/dev/config/aspell-words.pws")
  )


(progn
  ;; Nix

  ;;(require 'nix-mode)
  ;;(add-to-list 'auto-mode-alist '("\\.nix" . nix-mode))
  (add-hook 'nix-mode-hook #'company-mode)
  )


(progn
  ;; MMM

  (require 'mmm-mode)
  (require 'haskell-mode)
  (require 'clojure-mode)

  ;; (mmm-add-group 'nix-haskell
  ;;                '((sh-command
  ;;                   :submode haskell-mode
  ;;                   :face mmm-output-submode-face
  ;;                   :front "[^'a-zA-Z]/\\* haskell \\*/ ''[^']"
  ;;                   :back "''[^$\\]"
  ;;                   :include-front nil
  ;;                   :include-back nil
  ;;                   :front-offset 0
  ;;                   :end-not-begin t
  ;;                   )))

  (mmm-add-group 'nix-clojure
                 '((sh-command
                    :submode haskell-mode
                    :face mmm-output-submode-face
                    :front "[^'a-zA-Z]/\\* haskell \\*/ ''[^']"
                    :back "''[^$\\]"
                    :include-front nil
                    :include-back nil
                    :front-offset 0
                    :end-not-begin t
                    )))

  (setq mmm-global-mode 'maybe)
  ;;(mmm-add-mode-ext-class 'nix-mode "\\.nix\\'" 'nix-haskell)
  (mmm-add-mode-ext-class 'nix-mode "\\.nix\\'" 'nix-clojure)
  (add-hook 'nix-mode-hook #'mmm-mode))


(progn
  ;; Prettier
  (setq prettier-js-args '("--tab-width" "2"
                           "--trailing-comma" "all"
                           "--single-quote" "true")))


(progn
  ;; smartparens
  (require 'smartparens)
  (require 'smartparens-config)
  ;;(smartparens-global-strict-mode)

  (global-set-key (kbd "C-M-<right>") 'sp-forward-sexp)
  (global-set-key (kbd "C-M-f") 'sp-forward-sexp)
  (global-set-key (kbd "C-M-<left>") 'sp-backward-sexp)
  (global-set-key (kbd "C-M-b") 'sp-backward-sexp)

  (global-set-key (kbd "M-]") 'sp-unwrap-sexp)
  (global-set-key (kbd "C-M-<backspace>") 'sp-backward-kill-sexp)

  (global-set-key (kbd "C-M-w") (lambda () (interactive)
                                  (sp-mark-sexp)
                                  (sp-copy-sexp)))


  (global-set-key (kbd "C-<right>") 'sp-forward-slurp-sexp)
  (global-set-key (kbd "C-<left>") 'sp-forward-barf-sexp)

  (global-set-key (kbd "M-<left>") 'sp-backward-slurp-sexp)
  (global-set-key (kbd "M-<right>") 'sp-backward-barf-sexp)
  (global-set-key (kbd "C-k") 'sp-kill-hybrid-sexp))


(progn
  ;; Web Mode
  (setq web-mode-code-indent-offset 2)
  (add-hook 'web-mode-hook #'prettier-js-mode)
  )


(progn
  ;; WindMove
  (when (fboundp 'windmove-default-keybindings)
    (windmove-default-keybindings)))


(progn
  ;; Haskell
  (with-eval-after-load 'haskell-mode
    (define-key haskell-mode-map (kbd "C-c C-x") 'haskell-process-reload)
    (setq haskell-stylish-on-save t)))

(progn
  ;; Helm
  (global-set-key (kbd "C-c f") 'helm-find))

(require 'flycheck)


(progn
  ;; Yasnippet
  (require 'yasnippet)
  (yas-global-mode)
  (global-set-key (kbd "C-c y") 'yas-insert-snippet))

(progn
  ;; Dictcc
  (defun dictcc-at-point-or-query ()
    (interactive)
    (if (word-at-point)
        (dictcc-at-point)
      (call-interactively 'dictcc)))
  (global-set-key (kbd "C-c d") 'dictcc-at-point-or-query))

(progn
  ;; Show Info
  (defun show-info ()
    (interactive)
    (message "DATE: %s | BAT: %s"
             (shell-command-to-string "echo -n $(date)")
             (shell-command-to-string "echo -n $(acpi)")))

  (global-set-key (kbd "C-c i") 'show-info))

(progn
  ;; Dired
  (add-hook 'dired-mode-hook (lambda () (dired-hide-details-mode 1))))

(progn
  ;; Company
  (require 'company)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))

(progn
  ;; Regex
  (setq reb-re-syntax 'string))

(progn
  (setq ido-use-filename-at-point 'guess))

(progn
  ;; Helm
  (setq helm-buffers-fuzzy-matching t
        helm-recentf-fuzzy-match t)
  (helm-mode)
  (helm-autoresize-mode 1)
  (setq helm-autoresize-max-height 30)
  (setq helm-autoresize-min-height 30)
  (setq helm-split-window-in-side-p t)
  (setq helm-split-window-default-side 'below)

  ;;  (setq helm-buffer-help-message)

  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  (global-set-key (kbd "C-x b") 'helm-mini)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)

  (defadvice helm-display-mode-line (after undisplay-header activate)
    (setq header-line-format nil))

  (setq helm-mini-default-sources
        '(helm-source-buffers-list
          helm-source-bookmarks
          helm-source-recentf
          ;;helm-source-dired-recent-dirs
          helm-source-buffer-not-found)))

(defun setup-elm ()
  (interactive)
  (require 'flycheck)
  (require 'elm-mode)
  (require 'smartparens-config)


  (add-hook 'after-init-hook 'global-flycheck-mode)
  (add-hook 'flycheck-mode-hook 'flycheck-elm-setup)
  (with-eval-after-load 'company
    (add-to-list 'company-backends 'company-elm))
  (add-hook 'elm-mode-hook 'company-mode)
  (add-hook 'elm-mode-hook 'smartparens-mode)
  (add-hook 'elm-mode-hook 'flycheck-mode)

  (setq elm-format-on-save t))


(defun setup-elm18 ()
  (interactive)
  (setq elm-compile-command '("elm-make"))
  (setq elm-compile-arguments '("--yes" "--warn" "--output=elm.js"))
  (setq elm-format-command "elm-format")
  (setq elm-format-version "0.18"))


(progn
  (defun load-theme--disable-old-theme(theme &rest args)
    "Disable current theme before loading new one."
    (mapcar #'disable-theme custom-enabled-themes))

  (advice-add 'load-theme :before #'load-theme--disable-old-theme))

(progn
  ;;(add-hook 'prog-mode-hook 'highlight-indentation-mode)
  (add-hook 'prog-mode-hook 'yafolding-mode)
  (add-hook 'prog-mode-hook 'whitespace-cleanup-mode)
  (add-hook 'prog-mode-hook 'camelCase-mode)
  (add-hook 'prog-mode-hook 'column-number-mode)
  (add-hook 'prog-mode-hook 'fci-mode))

(progn
  (add-hook 'comint-mode-hook 'camelCase-mode)
  )

(progn
  (add-hook 'shell-mode-hook 'camelCase-mode)
  )

(progn
  (setq browse-url-browser-function 'browse-url-generic
        browse-url-generic-program "chromium-browser"))

(progn
  (global-set-key (kbd "<C-S-up>")     'buf-move-up)
  (global-set-key (kbd "<C-S-down>")   'buf-move-down)
  (global-set-key (kbd "<C-S-left>")   'buf-move-left)
  (global-set-key (kbd "<C-S-right>")  'buf-move-right))

(progn
  (global-set-key (kbd "M-i") 'helm-imenu-in-all-buffers))

(progn
  (require 'duplicate-thing)
  (global-set-key (kbd "M-c") 'duplicate-thing))

;; (progn
;;   (dynamic-spaces-global-mode 1))

(progn
  (avy-setup-default)
  ;;(global-set-key (kbd "C-:") 'avy-goto-char)
  (global-set-key (kbd "C-'") 'avy-goto-char-2)
  (global-set-key (kbd "C-.") 'avy-goto-char-timer))

(progn

  (deftheme my-light
    "Created 2018-04-17.")

  (setq visible-bell nil)

  (custom-theme-set-faces
   'my-light

   '(whitespace-line ((t (:background "grey90"))))

   '(fringe ((t (:background "grey100"))))

   '(avy-lead-face
     ((t (:background "goldenrod" :foreground "white"))))

   '(avy-lead-face-0
     ((t (:background "steel blue" :foreground "white"))))
   '(helm-ff-dotted-directory
     ((t (:background "dark gray" :foreground "black"))))

   '(helm-selection
     ((t (:background "seashell2" :distant-foreground "black"))))

   '(helm-source-header
     ((t (:background "azure2" :foreground "black" :box (:line-width 2 :color "azure2") :weight bold :height 1.0))))

   '(isearch
     ((t (:background "violet" :foreground "lightskyblue1"))))

   '(helm-source-header
     ((t (:background "azure2" :foreground "black" :box (:line-width 2 :color "azure2") :weight bold :height 1.0)))))

  (provide-theme 'my-light)

  (defun theme-dark ()
    (interactive)
    (load-theme 'zenburn)

    (custom-theme-set-faces
     'zenburn
     '(highlight-indentation-face ((t (:background "grey27"))))
     '(fringe ((t (:background "grey30"))))
     '(vertical-border ((t (:foreground "grey25"))))
     '(helm-selection ((t (:background "seashell3" :underline nil))))))

  (defun theme-light ()
    (interactive)
    (load-theme 'my-light)))


(require 'darkroom)


(progn
  (require 'disable-mouse)
  (global-disable-mouse-mode))

(progn
  (require 'advice)

  (defvar acc-auto-repeat-time 45000 ;; 100000
    "Interval in microseconds to detect keyboard auto-repeat.
\nIf an interactive command is repeated within this time, and invoked with
the same keyboard key, it is considered to be auto-repeated.")

  (defvar acc--last-time (current-time))
  (defvar acc--next-multiplier '(1))
  (defvar acc--last-command-event nil)

  (defun acc-time-diff (time1 time2)
    "Difference between TIME1 and TIME2 in microseconds.
Assume TIME1 is before or equal to TIME2.
Return 1000000 if diff is larger than one second.
See `current-time' for time format."
    (let ((hi (- (car time2) (car time1)))
          (s (- (nth 1 time2) (nth 1 time1)))
          (us (- (nth 2 time2) (nth 2 time1))))
      (cond ((/= hi 0)    1000000)
            ((=  s 1)     (+ 1000000 us))
            ((/= s 0)     1000000)
            (t            us))
      ))

  ;; `accelerate' is a macro. It could have most of the logic in
  ;; `acc-remove-advice', `acc-save-mult' and `acc-pump-arg', but
  ;; placing them in separate functions that aren't macros will allow
  ;; the expansion of `accelerate' to be smaller. It also enhances
  ;; readability, just slightly.

  (defun acc-remove-advice (funct class name)
    ;; Remove a specific piece of advice.
    ;; Basically the reverse of `defadvice'.
    (if (ad-find-advice funct 'before 'accelerate)
        (progn
          (ad-remove-advice funct 'before 'accelerate)
          (ad-activate-on funct)
          nil)))

  (defun acc-save-mult (multiplier symb)
    ;; Normalize MULTIPLIER, store it in a property of SYMB, and return it.
    ;; If MULTIPLIER is a number, normalize it by putting it in a list, otherwise
    ;; return it as it is. `nil' is returned as it is too.
    (if (numberp multiplier) (setq multiplier (list multiplier)))
    (put symb 'accelerate multiplier)
    multiplier)

  (defun acc-pump-arg (arg0 symb)
    ;; Given an argument value ARG0 assumed to be the first arg of an advised
    ;; command, compute and return a replacement value for that arg.
    ;; If it is concluded that this is not an auto-repeated invocation of
    ;; the advised command, ARG0 is returned unchanged.
    ;; SYMB is the command symbol, which is used to get the multiplier list
    ;; stored in a property on that symbol.
    ;; Variables `acc--last-command-event', `acc--last-time' and/or
    ;; `acc--next-multiplier' are updated.
    (if (and (eq last-command-event acc--last-command-event)
             (not defining-kbd-macro)
             (not executing-kbd-macro)
             (eq arg0 1))
        (progn
          (let ((curr (current-time)))
            (if (< (acc-time-diff acc--last-time curr) acc-auto-repeat-time)
                (setq arg0 (car acc--next-multiplier)
                      acc--next-multiplier (or (cdr acc--next-multiplier)
                                               acc--next-multiplier))
              ;; else  too long since last time
              (setq acc--next-multiplier (get symb 'accelerate)))
            (setq acc--last-time curr)))
      ;; else  temporary disabled
      (setq acc--last-command-event last-command-event))
    arg0)

;;;###autoload
  (defmacro accelerate (command multiplier)
    "Advise COMMAND so its numeric argument is increased when repeated quickly.
\nCOMMAND should be a symbol name of an interactive command where the first arg
is 1 by default. Normally that is a function declared with \(interactive \"p\").
COMMAND should not be quoted since this is a macro.
\nMULTIPLIER is a number \(or a list of numbers\) to become the first arg of the
command when the command is repeated quickly, or `nil' to remove acceleration.
If MULTIPLIER is a list of numbers, each consecutive repeated invocation of the
command will use the next number in the list. If the end of the list is reached
the last number is used again in further repeated invocations.
\nAlso see variable `acc-auto-repeat-time'."
    `(if (acc-save-mult ,multiplier ',command)
         (defadvice ,command (before accelerate activate)
           "Accelerated when auto-repeated. See `accelerate'"
           (if (called-interactively-p 'any)
               (ad-set-arg 0 (acc-pump-arg (ad-get-arg 0) ',command))))
       ;; else
       (acc-remove-advice ',command 'before 'accelerate)))

  (provide 'accelerate)


  (require 'helm)
  (progn
    (accelerate previous-line 4)
    (accelerate next-line 4)
    (accelerate screen-scroll-up 4)
    (accelerate screen-scroll-down 4)
    (accelerate backward-char 6)
    (accelerate forward-char 6)
    (accelerate right-char 6)
    (accelerate left-char 6)
    (accelerate delete-backward-char 4)
    (accelerate paredit-backward-delete 4)
    (accelerate paredit-forward-delete 4)
    (accelerate magit-previous-line 4)
    (accelerate magit-next-line 4)
    (accelerate dired-next-line 4)
    (accelerate dired-previous-line 4)
    (accelerate helm-next-line 4)
    (accelerate helm-previous-line 4)
    ))

(progn
  (autoload 'helm-company "helm-company")
  (eval-after-load 'company
    '(progn
       (define-key company-mode-map (kbd "C-:") 'helm-company)
       (define-key company-active-map (kbd "C-:") 'helm-company))))


(progn
  (require 'whitespace)
  (setq whitespace-style '(face empty tabs lines-tail trailing))
  ;;(global-whitespace-mode t)
  )

(defun fresh-shell-fullscreen ()
  (interactive)
  (shell (concat "shell-" (car (split-string (shell-command-to-string "uuidgen")))))
  (delete-other-windows))


(progn
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)


  (global-set-key (kbd "C->") 'mc/mark-next-like-this)

  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

(progn
  (require 'dired )

  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)

  (define-key dired-mode-map (kbd "q") (lambda () (interactive) (find-alternate-file ".."))))

(progn
  (add-hook 'dired-mode-hook
            (lambda ()
              (define-key dired-mode-map (kbd "^")
                (lambda ()
                  (interactive)
                  (find-alternate-file ".."))))))

(progn
  (setq ibuffer-saved-filter-groups
        '(("home"
;;           ("Elm" (mode . elm-mode))
           ("Haskell" (mode . haskell-mode))
           ("Shell" (mode . shell-mode))
           ("Dired" (mode . dired-mode))
           ("Nix" (mode . nix-mode))
           ("Magit" (name . "\*magit"))
           ("Help" (or (name . "\*Help\*")
                       (name . "\*Apropos\*")
                       (name . "\*info\*"))))))

  (add-hook 'ibuffer-mode-hook
            '(lambda ()
               (ibuffer-switch-to-saved-filter-groups "home"))))

(progn
  (require 'psc-ide)



  (add-hook 'purescript-mode-hook
            (lambda ()
              (define-key purescript-mode-map (kbd "C-c l") 'flycheck-mode)
              (psc-ide-mode)
              (company-mode)
              (flycheck-mode)
              (turn-on-purescript-indentation)
              (haskell-decl-scan-mode)))
  )


(progn
  (setq flycheck-display-errors-function 'flycheck-display-error-messages-unless-error-list))


(progn
  (global-set-key (kbd "M-p") (lambda () (interactive) (scroll-down 5)))
  (global-set-key (kbd "M-n") (lambda () (interactive) (scroll-up 5))))

(progn
  (defun next-line-non-empty-column (arg)
    "Find next line, on the same column, skipping those that would
end up leaving point on a space or newline character."
    (interactive "p")
    (let* ((hpos (- (point) (point-at-bol)))
           (re (format "^.\\{%s\\}[^\n ]" hpos)))
      (cond ((> arg 0)
             (forward-char 1) ; don't match current position (can only happen at column 0)
             (re-search-forward re))
            ((< arg 0)
             (forward-char -1)           ; don't match current position.
             (re-search-backward re)
             (goto-char (match-end 0))))
      ;; now point is after the match, let's go back one column.
      (forward-char -1)))

  (defun previous-line-non-empty-column (arg)
    ""
    (interactive "p")
    (next-line-non-empty-column (- arg)))

  (global-set-key (kbd "C-S-n") 'next-line-non-empty-column)
  (global-set-key (kbd "C-S-p") 'previous-line-non-empty-column))

(server-start)

(progn

  (defhydra hydra-flycheck (:color blue)
    "
  ^
  ^Flycheck^          ^Errors^            ^Checker^
  ^────────^──────────^──────^────────────^───────^─────
  _q_ quit            _<_ previous        _?_ describe
  _M_ manual          _>_ next            _d_ disable
  _v_ verify setup    _f_ check           _m_ mode
  ^^                  _l_ list            _s_ select
  ^^                  ^^                  ^^
  "
    ("q" nil)
    ("<" flycheck-previous-error :color pink)
    (">" flycheck-next-error :color pink)
    ("?" flycheck-describe-checker)
    ("M" flycheck-manual)
    ("d" flycheck-disable-checker)
    ("f" flycheck-buffer)
    ("l" flycheck-list-errors)
    ("m" flycheck-mode)
    ("s" flycheck-select-checker)
    ("v" flycheck-verify-setup))

  (global-set-key (kbd "C-C C-f") 'hydra-flycheck/body))


(progn
  (defun split-3-windows-horizontally-evenly ()
    (interactive)
    (command-execute 'split-window-horizontally)
    (command-execute 'split-window-horizontally)
    (command-execute 'balance-windows)
    )

  (global-set-key (kbd "C-x 4") 'split-3-windows-horizontally-evenly))

(progn
  (global-set-key (kbd "C-c w") 'scratch-palette-popup)
  )

(progn
  (add-hook 'edit-server-start-hook 'markdown-mode))

(progn
  ;; (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls)
  )

(progn
  (when (fboundp 'electric-indent-mode) (electric-indent-mode -1)))

(progn
  (require 'expand-region)
  (global-set-key (kbd "C-=") 'er/expand-region))

(defun text-scale-increase-everywhere ()
  (interactive)
  (set-face-attribute 'default nil :height
                      (+ (face-attribute 'default :height)
                         5)))

(defun text-scale-decrease-everywhere ()
  (interactive)
  (set-face-attribute 'default nil :height
                      (- (face-attribute 'default :height)
                         5)))

(require 'helm-company)

(defun kill-all-tmp-shells ()
  (interactive)
  (dolist (buf (seq-filter (lambda (buffer)
                             (string-match-p "^shell-[0-9a-z]+-" (buffer-name buffer)))
                           (buffer-list)))
    (let ((proc (get-buffer-process buf)))
      (when proc
        (delete-process proc)))
    (kill-buffer buf)))

(set-face-attribute 'comint-highlight-prompt nil
                    :inherit nil)

(progn
  (move-text-default-bindings))

(defun er-sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

;; (progn

;; (defun gen-value-sig (val-name start-n n-args multiline)
;;   (format "${%d:%s} :%s%s"
;;           start-n
;;           val-name
;;           (if multiline "\n    " " ")
;;           (string-join (mapcar (lambda (i)
;;                                  (format "${%d:a}"
;;                                          i))
;;                                (number-sequence (+ start-n 1) (+ start-n n-args 1)))
;;                        (format "%s-> "
;;                                (if multiline "\n    " " ")))))

;; (defun gen-value-def (val-name start-n n-args)
;;   (format "${%d:%s} %s= ${%d:x}"
;;           start-n
;;           val-name
;;           (string-join (mapcar (lambda (i)
;;                                  (format "${%d:%s} "
;;                                          i
;;                                          (if (= (+ start-n 2) i) "x" "_")
;;                                          ))
;;                                (number-sequence (+ start-n 2) (+ start-n n-args 1))))
;;           (+ start-n n-args 2)))

;; (defun gen-value-sig-def (val-name n-args multiline)
;;   (format "${1:%s}\n%s"
;;           (gen-value-sig val-name 2 n-args multiline)
;;           (gen-value-def "$2$(yas-text)" (+ n-args 4) n-args)))

;; (defun gen-case (n-branches)
;;   (format "case ${1:n} of\n%s"
;;           (string-join
;;            (mapcar (lambda (i)
;;                      (format "    ${%d:%d} ->\n        ${%d:()}"
;;                              (* i 2) i (+ (* i 2) 1)))
;;                    (number-sequence 1 n-branches))
;;            "\n\n")))

;; (defun gen-list-like (open close length multiline)
;;   (if (= length 0)
;;       (format "%s%s" open close)
;;     (format "%s %s%s%s"
;;             open
;;             (string-join
;;              (mapcar (lambda (i)
;;                        (format "${%d}" i))
;;                      (number-sequence 0 (- length 1)))
;;              (format "%s, "
;;                      (if multiline "\n" "")))
;;             (if multiline "\n" " ")
;;             close)))

;; (defun gen-list (length multiline)
;;   (gen-list-like "[" "]" length multiline))

;; (defun gen-tuple (length multiline)
;;   (gen-list-like "(" ")" length multiline))

;; (defun last-frag-module-name (text)
;;   (car
;;    (reverse (split-string text "\\."))))


;; (defun gen-pipe (n-steps multiline)
;;   (string-join
;;    (mapcar (lambda (i)
;;              (format "|> ${%d}" i))
;;            (number-sequence 1 n-steps))
;;    (if multiline "\n" " ")))

;; (setq yas/triggers-in-field t)

;; (yas-define-snippets
;;  'elm-mode
;;  `(;; Statements

;;    ("mod"
;;     "module ${1: } exposing (${2:..})"
;;     "module"
;;     nil nil ((yas/indent-line nil)))

;;    ("imp"
;;     "import ${1: }${2: as ${3:$1$(last-frag-module-name yas-text)}}${4: exposing (${5:..})}"
;;     "import"
;;     nil nil ((yas/indent-line nil)))

;;    ("doc"
;;     "{-| ${1}\n-}"
;;     "doc string")

;;    ("exa"
;;     "exposing (..)"
;;     "exposing all")

;;    ("ex"
;;     "exposing (${1})"
;;     "exposing")

;;    ;; Primitive Types

;;    ("S"
;;     "String"
;;     "String"
;;     nil nil ((yas/indent-line nil)))

;;    ("B"
;;     "Bool"
;;     "Bool"
;;     nil nil ((yas/indent-line nil)))

;;    ("I"
;;     "Int"
;;     "Int"
;;     nil nil ((yas/indent-line nil)))

;;    ("C"
;;     "Char"
;;     "Char"
;;     nil nil ((yas/indent-line nil)))

;;    ("F"
;;     "Float"
;;     "Float"
;;     nil nil ((yas/indent-line nil)))

;;    ("U"
;;     "()"
;;     "Unit"
;;     nil nil ((yas/indent-line nil)))

;;    ;; Composed Types

;;    ("L"
;;     "List (${1:a})"
;;     "List"
;;     nil nil ((yas/indent-line nil)))

;;    ("D"
;;     "Dict (${1:a}) (${2:b})"
;;     "Dict"
;;     nil nil ((yas/indent-line nil)))

;;    ("Cm"
;;     "Cmd ({1:a})"
;;     "Cmd"
;;     nil nil ((yas/indent-line nil)))

;;    ("De"
;;     "Debug"
;;     "Debug"
;;     nil nil ((yas/indent-line nil)))


;;    ("Se"
;;     "Set (${1:a})"
;;     "Set"
;;     nil nil ((yas/indent-line nil)))

;;    ("M"
;;     "Maybe (${1:a})"
;;     "Maybe"
;;     nil nil ((yas/indent-line nil)))

;;    ("R"
;;     "Result (${1:err}) (${2:a})"
;;     "Result"
;;     nil nil ((yas/indent-line nil)))

;;    ;;

;;    (".->"
;;     "${1:a} -> ${2:b}"
;;     "arrow"
;;     nil nil ((yas/indent-line nil)))


;;    ;; Language constructs

;;    ("if"
;;     "if ${1} then\n    ${2}\nelse\n    ${3}"
;;     "if"
;;     nil nil ((yas/indent-line 'fixed)))

;;    ,@(mapcar
;;       (lambda (i)
;;         `(,(format "case%d" i)
;;           ,(gen-case i)
;;           ,(format "case %d" i)
;;           nil nil ((yas/indent-line 'fixed))
;;           ))
;;       (number-sequence 0 9))

;;    ;; Value Definitions

;;    ,@(cl-loop
;;       for name in '(x y z f g h j k)
;;       nconc (cl-loop
;;              for i from 0 to 9
;;              nconc (cl-loop
;;                     for multiline in `(,nil ,@(if (> i 0) (list t)))
;;                     collect `(,(format "%s%s%s" name (if (= i 0) "" (format "%d" i)) (if multiline "m" ""))
;;                               ,(gen-value-sig-def name i multiline)
;;                               ,(format "value %s %d%s" name i (if multiline " multiline" ""))
;;                               nil nil ((yas/indent-line nil))))))

;;    ;; Composed

;;    ,@(cl-loop
;;       for i from 0 to 9
;;       nconc (cl-loop
;;              for multiline in '(t nil)
;;              collect `(,(format "ls%d%s" i (if multiline "m" ""))
;;                        ,(gen-list i multiline)
;;                        ,(format "list %d%s" i (if multiline "multiline" ""))
;;                        nil nil ((yas/indent-line 'fixed)))))

;;    ,@(cl-loop
;;       for i from 0 to 9
;;       nconc (cl-loop
;;              for multiline in '(t nil)
;;              collect `(,(format "tp%d%s" i (if multiline "m" ""))
;;                        ,(gen-list i multiline)
;;                        ,(format "tuple %d%s" i (if multiline "multiline" ""))
;;                        nil nil ((yas/indent-line 'fixed)))))

;;    ;; Control Flow

;;    ,@(mapcar
;;       (lambda (i)
;;         `(,(format "p%d" i)
;;           ,(gen-pipe i nil)
;;           ,(format "pipe %d multiline" i)
;;           ))
;;       (number-sequence 0 9))

;;    ,@(mapcar
;;       (lambda (i)
;;         `(,(format "p%dm" i)
;;           ,(gen-pipe i t)
;;           ,(format "pipe %d" i)
;;           ))
;;       (number-sequence 0 9))

;;    ;; Convenience


;;    ("test"
;;     ,(string-join
;;       '("test \"${1:}\" <| "
;;         "  \_ -> "
;;         "      ${2:x} "
;;         "          |> Expect.equal ${3:} ")
;;       "\n")
;;     "test"))

;;  )

;; (progn

;;   (defun elm-make-single-line ()
;;     (interactive)
;;     (if (region-active-p)
;;         (replace-regexp "\n *\\(,\\| ->\\|]\\)" "\\1"
;;                         nil (region-beginning) (region-end))))

;;   (defun keys-elm-mode-hook ()
;;     (local-set-key (kbd "C-c l") 'elm-make-single-line))

;;   (add-hook 'elm-mode-hook 'keys-elm-mode-hook)


;;   ;; (defun adjust-type-signatures ()
;;   ;;   (let ((regex-name "[a-z][a-zA-Z0-9_]*"))
;;   ;;     (when (eq major-mode 'elm-mode)
;;   ;;       (save-excursion
;;   ;;         (goto-char 1)
;;   ;;         (while (search-forward-regexp (format "\n%s\\( :.*\n\\(%s\\) \\)" regex-name regex-name) nil t)
;;   ;;           (replace-match (format "\n%s%s" (match-string 2) (match-string 1) ) t nil))))))

;;   ;; (add-hook 'before-save-hook #'adjust-type-signatures)
;;   )

;; (progn

;;   (setq elm-regex-def "\n[a-z][a-zA-Z0-9_]* :\\|\ntype")

;;   (defun elm-next-def ()
;;     (interactive)
;;     (end-of-line)
;;     (search-forward-regexp elm-regex-def nil t)
;;     (beginning-of-line))

;;   (defun elm-prev-def ()
;;     (interactive)
;;     (search-backward-regexp elm-regex-def nil t)
;;     (next-line)
;;     (beginning-of-line))

;;   (defun elm-highlight-def ()
;;     (interactive)
;;     (search-forward-regexp "\n\n\n" nil t)
;;     (previous-line)
;;     (set-mark (point))
;;     (elm-prev-def)
;;     (activate-mark))

;;   (global-set-key (kbd "C-{") 'elm-prev-def)
;;   (global-set-key (kbd "C-}") 'elm-next-def)
;;   (global-set-key (kbd "C-M-h") 'elm-highlight-def)))



(setq timer
      (progn
        (setq clean-buffer-list-delay-general (/ 30 60.0 24.0)) ;; min
        (setq timer
              (run-with-timer 0 (* 10 60) (lambda () ;; min
                                            (clean-buffer-list))))))

(progn
  (defalias 'yes-or-no-p 'y-or-n-p))


(progn
  (require 'projectile)
  ;; (setq projectile-project-search-path '("~/dev/"))
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1)
  (projectile-global-mode)
  (require 'helm-projectile)
  (helm-projectile-on))


(defun dired-dotfiles-toggle ()

  "Show/hide dot-files"
  (interactive)
  (when (equal major-mode 'dired-mode)
    (if (or (not (boundp 'dired-dotfiles-show-p)) dired-dotfiles-show-p) ; if currently showing
        (progn
          (set (make-local-variable 'dired-dotfiles-show-p) nil)
          (message "h")
          (dired-mark-files-regexp "^\\\.")
          (dired-do-kill-lines))
      (progn (revert-buffer) ; otherwise just revert to re-show
             (set (make-local-variable 'dired-dotfiles-show-p) t)))))


(progn
  (require 'dired-x)
  (setq-default dired-omit-files-p t) ; Buffer-local variable
  (setq dired-omit-files (concat dired-omit-files "\\|^\\..+$")))


(progn
  (require 'hydra)

  (defhydra hydra-screens nil
    "screens"
    ("1" (shell-command cmd-screens-1) "1" :exit t)
    ("2" (shell-command cmd-screens-2) "2" :exit t)
    ("m" (shell-command cmd-screens-mirror) "mirror" :exit t))

  (defhydra hydra-keyboard nil
    "keyboard"
    ("d" (shell-command cmd-keyboard-de) "de" :exit t)
    ("u" (shell-command cmd-keyboard-us) "us" :exit t))

  (defhydra hydra-zoom nil
    "zoom"
    ("+" text-scale-increase-everywhere "in")
    ("-" text-scale-decrease-everywhere "out"))

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
  )


(progn
  (require 'shell-switcher)

  (setq shell-switcher-mode t)

  (defun make-shell ()
    "Create a new 'shell'."
    (shell (generate-new-buffer-name "*shell*")))

  (setq-default shell-switcher-new-shell-function 'make-shell)

  (add-hook 'shell-mode-hook 'shell-switcher-manually-register-shell))

(progn
  (setq browse-url-browser-function 'browse-url-chromium))


(progn
  (defun bookmark-reload ()
    (interactive)
    ;; (bookmark-load "~/dev/nix-config/modules/emacs/bookmarks" t)
    ))

(progn
  (require 'fill-column-indicator)
  (setq fci-rule-column 80)
  (setq fci-rule-color "gainsboro")
  (setq fci-rule-width 1))

(defun xah-copy-file-path (&optional @dir-path-only-p)
  "Copy the current buffer's file path or dired path to `kill-ring'.
Result is full path.
If `universal-argument' is called first, copy only the dir path.

If in dired, copy the file/dir cursor is on, or marked files.

If a buffer is not file and not dired, copy value of `default-directory' (which is usually the “current” dir when that buffer was created)

URL `http://ergoemacs.org/emacs/emacs_copy_file_path.html'
Version 2017-09-01"
  (interactive "P")
  (let (($fpath
         (if (string-equal major-mode 'dired-mode)
             (progn
               (let (($result (mapconcat 'identity (dired-get-marked-files) "\n")))
                 (if (equal (length $result) 0)
                     (progn default-directory )
                   (progn $result))))
           (if (buffer-file-name)
               (buffer-file-name)
             (expand-file-name default-directory)))))
    (kill-new
     (if @dir-path-only-p
         (progn
           (message "Directory path copied: 「%s」" (file-name-directory $fpath))
           (file-name-directory $fpath))
       (progn
         (message "File path copied: 「%s」" $fpath)
         $fpath )))))

(defun find-file-at-point-with-line()
  "if file has an attached line num goto that line, ie boom.rb:12"
  (interactive)
  (setq line-num 0)
  (save-excursion
    (search-forward-regexp "[^ ]:" (point-max) t)
    (if (looking-at "[0-9]+")
        (setq line-num (string-to-number (buffer-substring (match-beginning 0) (match-end 0))))))
  (find-file-at-point)
  (if (not (equal line-num 0))
      (goto-line line-num)))

(progn
  (global-set-key (kbd "<C-tab>") 'other-window))

(progn
  (global-set-key (kbd "<M-tab>") 'helm-mini))

(progn
  (require 'dim)
  (dim-minor-names
   '((mmm-mode   nil)
     (camelCase-mode nil)
     (disable-mouse-global-mode nil)
     (yas-minor-mode nil)
     (whitespace-cleanup-mode nil)
     (flyspell-mode nil)
     (projectile-mode nil)
     (my-keys-minor-mode nil)
     (auto-complete-mode nil)
     (eldoc-mode nil)
     (paredit-mode nil)
     )))

(progn
  (defun my-get-project-name ()
    (when-let
	((proj (my-get-project-dir))) ;; "/user/home/proj/"
      (->> proj
	   (directory-file-name) ;; "/user/home/proj"
	   (file-name-nondirectory) ;; "proj"
	   )))

  (defun my-get-project-dir ()
    (when-let
	((proj (cdr-safe (project-current)))) ;; "~/proj/"
      (expand-file-name proj) ;; "/user/home/proj/"
      ))

  (with-eval-after-load 'subr-x
    (setq-default mode-line-buffer-identification
		  '(:eval (format-mode-line
			   (propertized-buffer-identification
			    (if-let ((file-name (buffer-file-name)))
				(concat (my-get-project-name)
					" "
					(file-relative-name
					 file-name
					 (my-get-project-dir)))
			      "%b")))))))

(progn
  (require 'neotree)
  (global-set-key [f8] 'neotree-toggle)

  (setq neo-smart-open t)
  (setq projectile-switch-project-action 'neotree-projectile-action)
  (setq neo-window-position 'right)
  (setq neo-theme 'arrow))

(progn
  (add-to-list
   'comint-preoutput-filter-functions
   (lambda (output)
     (replace-regexp-in-string "\033\[[0-9]+[GKJ]" "" output))))

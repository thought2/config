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

;; A person, work-in-progress Emacs configuration File.


;;; Code:

(defun mee ()
  "Doo."
  (interactive)
  (message "am here"))

(defun cfg:recent-file ()
  "Who can live without this feature?"

  (require 'recentf)
  (recentf-mode t)
  (setq recentf-max-saved-items 50)

  (defun find-file-ido ()
    "Find a recent file using Ido."
    (interactive)
    (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
      (when file
        (find-file file))))

  (global-set-key (kbd "C-x C-r") #'find-file-ido))


(defun cfg:simpler ()
  "Configuration to make Emacs look less noisy."

  (setq inhibit-splash-screen t)
  (setq initial-scratch-message "") 
  (setq inhibit-startup-echo-area-message "m")
  (blink-cursor-mode 0)
  (fringe-mode 4))


(defun cfg:editing ()
  "Configuration for general editing functionality."

  (defun duplicate-line ()
    "Duplicates the current line."
    (interactive)
    (move-beginning-of-line 1)
    (kill-line)
    (yank)
    (open-line 1)
    (forward-line 1)
    (yank))

  (global-set-key (kbd "C-c d") #'duplicate-line)
  (global-set-key (kbd "C-c r") #'replace-string)
  (global-set-key (kbd "C-c C-c") #'comment-or-uncomment-region))


(defun cfg:paredit ()
  "Paredit configuration."
  (defun duplicate-sexpr ()
    (interactive)
    (copy-region-as-kill (save-excursion
                           (paredit-backward)
                           (point))
                         (point))
    (paredit-newline)
    (yank))

  (defun copy-sexpr ()
    (interactive)
    (copy-region-as-kill (save-excursion
                           (paredit-backward)
                           (point))
                         (point)))

  (global-set-key (kbd "C-c x") #'duplicate-sexpr)
  (global-set-key (kbd "C-c c") #'copy-sexpr)
  (global-set-key (kbd "C-c p") #'paredit-mode))


(defun cfg:elisp ()
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
  (add-hook 'emacs-lisp-mode-hook #'eldoc-mode)
  (add-hook 'emacs-lisp-mode-hook #'auto-complete-mode)
  (add-hook 'emacs-lisp-mode-hook #'company-mode))


(defun cfg:cider ()
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


(defun cfg:clojure ()
  "Configuration for Clojure."
  (add-hook 'clojure-mode-hook #'aggressive-indent-mode)
  (add-hook 'clojure-mode-hook #'paredit-mode)
  (add-hook 'clojure-mode-hook #'eldoc-mode)
  (add-hook 'clojure-mode-hook #'auto-complete-mode)
  (add-hook 'clojure-mode-hook #'company-mode))


(defun cfg:clojure-script ()
  "Configuration for ClojureScript."
  (add-hook 'clojure-script-mode-hook #'aggressive-indent-mode)
  (add-hook 'clojure-script-mode-hook #'paredit-mode)
  (add-hook 'clojure-script-mode-hook #'eldoc-mode)
  (add-hook 'clojure-script-mode-hook #'auto-complete-mode)
  (add-hook 'clojure-script-mode-hook #'company-mode))


(defun cfg:startup ()
  (shell))


(defun cfg:shell () 
  (global-set-key (kbd "C-c s") 'shell))


(defun cfg:windows ()

  (defun set-window-abs-height (height)
    (enlarge-window (- height (window-total-height))))

  (defun set-window-abs-width (width)
    (enlarge-window-horizontally (- width (window-total-width))))

  (defun toggle-width () 
    (interactive)
    (let ((width (round (/ (frame-total-cols) 4))))
      (set-window-abs-width (if (= (window-total-width) width)
                                (- (frame-total-cols) width 1)
                              width))))

  (defun toggle-height ()
    (interactive)
    (let ((height (round (/ (frame-total-lines) 4))))
      (set-window-abs-height (if (= (window-total-height) height)
                                 (- (frame-total-lines) height 1)
                               height))))

  (windmove-default-keybindings)

  (global-set-key (kbd "C-c h") #'toggle-height)
  (global-set-key (kbd "C-c w") #'toggle-width))


(defun cfg:typography ()
  "Config for typography."

  (global-set-key (kbd "C-x C-+")
                  (lambda ()
                    "Bigger."
                    (interactive)
                    (text-scale-increase 0.2)))

  (global-set-key (kbd "C-x C--")
                  (lambda ()
                    "Smaller."
                    (interactive)
                    (text-scale-increase -0.2)))

  (set-frame-font "DejaVu Sans Mono")
  (set-face-attribute 'default nil :height 79))


(defun cfg:language ()
  (setq lexical-binding t))


(defun cfg:minibuffer ()
  (add-hook 'eval-expression-minibuffer-setup-hook #'paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'show-paren-mode))


(defun cfg:elm ()
  (require 'flycheck)
  (require 'elm-mode)
  (add-hook 'after-init-hook #'global-flycheck-mode)
  (add-hook 'flycheck-mode-hook 'flycheck-elm-setup)
  (with-eval-after-load 'company
    (add-to-list 'company-backends 'company-elm))
  (add-hook 'elm-mode-hook #'company-mode))


(defun cfg:typescript ()
  "TypeScript configuration."

  (defun setup-tide-mode ()
    (interactive) 
    (tide-setup)
    (flycheck-mode +1)
    (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (eldoc-mode +1)
    (tide-hl-identifier-mode +1) 
    (company-mode +1)

    ;; aligns annotation to the right hand side
    (setq company-tooltip-align-annotations t)

    ;; formats the buffer before saving
    (add-hook 'before-save-hook 'tide-format-before-save)

    (add-hook 'typescript-mode-hook #'setup-tide-mode)

    ;; tsx

    (require 'web-mode)
    (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
    (add-hook 'web-mode-hook
              (lambda ()
                (when (string-equal "tsx" (file-name-extension buffer-file-name))
                  (setup-tide-mode))))
    ;; enable typescript-tslint checker
    (flycheck-add-mode 'typescript-tslint 'web-mode)

    ;;
    (setq sp-base-key-bindings 'smartparens)

    ;; Always start Smartparens mode in js-mode.
    (add-hook 'typescript-mode-hook #'smartparens-mode))


  ;; TODO: check inconsistency below: ' vs #'
  (add-hook 'before-save-hook 'tide-format-before-save)
  (add-hook 'typescript-mode-hook #'setup-tide-mode))


(defun cfg:magit ()
  "Magit configuration."
  (global-set-key (kbd "C-x g") 'magit-status)
  (global-set-key (kbd "C-x M-g") 'magit-dispatch-popup))

(defun cfg:direx ()
  "Configuration of the tree-based file browser direx."
  (global-set-key (kbd "C-x C-j") 'direx:jump-to-directory))

(defun cfg:spelling ()
  "General spelling configuration."

  ;; enable spell checking for comments in all programming modes
  (add-hook 'prog-mode-hook #'flyspell-prog-mode)

  ;; FIXME: get impure path from nix configuration.
  (setq ispell-personal-dictionary "/home/mbock/dev/config/aspell-words.pws"))

(defun cfg:nix ()
  "Nix configuration.")

(defun cfg:mmm ()
  "Configuration for MMM-Mode"

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

(defun cfg:prettier ()
  (setq prettier-js-args '("--tab-width" "2"
                           "--trailing-comma" "all"
                           "--single-quote" "true")))

(defun cfg:smartparens () 
  (require 'smartparens)
  (smartparens-global-strict-mode)

  (global-set-key (kbd "C-<right>") 'sp-forward-slurp-sexp)
  (global-set-key (kbd "C-<left>") 'sp-forward-barf-sexp)

  (global-set-key (kbd "M-<left>") 'sp-backward-slurp-sexp)
  (global-set-key (kbd "M-<right>") 'sp-backward-barf-sexp))

(progn
  (cfg:simpler)
  (cfg:language)
  (cfg:startup)
  (cfg:editing)
  (cfg:magit)
  (cfg:direx)
  (cfg:elm)
  (cfg:paredit)
  (cfg:recent-file) 
  (cfg:elisp)
  (cfg:clojure)
  (cfg:clojure-script)
  (cfg:cider)
  (cfg:shell)
  (cfg:nix)
  (cfg:windows)
  (cfg:typography)
  (cfg:minibuffer)
  (cfg:typescript)
  (cfg:spelling)
  (cfg:mmm)
  
  (cfg:prettier)
  (cfg:smartparens)
  )


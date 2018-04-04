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
  (setq inhibit-startup-screen t)
  (setq inhibit-startup-message t)
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

  (global-set-key (kbd "C-c C-d") #'duplicate-line)
  (global-set-key (kbd "C-c C-r") #'replace-string))


(defun cfg:buffer ()
  "Buffer configuration."

  (global-set-key (kbd "C-c n") #'rename-buffer)
  (global-set-key (kbd "C-c u") #'rename-uniquely))


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
  ;;(add-hook 'emacs-lisp-mode-hook #'paredit-mode)
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
  ;;(add-hook 'cider-repl-mode-hook #'paredit-mode)
  (add-hook 'cider-repl-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'auto-complete-mode)
  (add-hook 'cider-repl-mode-hook #'company-mode))


(defun cfg:clojure ()
  "Configuration for Clojure."
  (add-hook 'clojure-mode-hook #'aggressive-indent-mode)
  ;;(add-hook 'clojure-mode-hook #'paredit-mode)
  (add-hook 'clojure-mode-hook #'eldoc-mode)
  (add-hook 'clojure-mode-hook #'auto-complete-mode)
  (add-hook 'clojure-mode-hook #'company-mode))


(defun cfg:clojure-script ()
  "Configuration for ClojureScript."
  (add-hook 'clojure-script-mode-hook #'aggressive-indent-mode)
  ;;(add-hook 'clojure-script-mode-hook #'paredit-mode)
  (add-hook 'clojure-script-mode-hook #'eldoc-mode)
  (add-hook 'clojure-script-mode-hook #'auto-complete-mode)
  (add-hook 'clojure-script-mode-hook #'company-mode))


(defun cfg:startup ()
  (shell))


(defun cfg:shell ()
  (global-set-key (kbd "C-c s") 'shell))


(defun cfg:windows ()

  (defun set-buffer-width-per10 (step-w_)
    (interactive "PX of 10? ")
    (let* ((step-w (or step-w_ 7))
           (max-steps 10))
      (window-resize nil
                     (- (* step-w (round (/ (x-display-pixel-width) max-steps)))
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


(defun cfg:typography ()
  "Config for typography."

  (set-frame-font "DejaVu Sans Mono")
  (set-face-attribute 'default nil :height 79))


(defun cfg:language ()
  (setq lexical-binding t))


(defun cfg:minibuffer ()
  ;;  (add-hook 'eval-expression-minibuffer-setup-hook #'paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'show-paren-mode))


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

  (setq sp-base-key-bindings 'smartparens)
  (add-hook 'typescript-mode-hook #'smartparens-mode)
  ;; TODO: check inconsistency below: ' vs #'
  ;; (add-hook 'before-save-hook 'tide-format-before-save)
  (add-hook 'typescript-mode-hook #'setup-tide-mode))


(defun cfg:direx ()
  "Configuration of the tree-based file browser direx."
  (global-set-key (kbd "C-x C-j") 'direx:jump-to-directory))


(defun cfg:spelling ()
  "General spelling configuration."

  ;; enable spell checking for comments in all programming modes
  (add-hook 'prog-mode-hook #'flyspell-prog-mode)
  (add-hook 'text-mode-hook #'flyspell-mode)

  ;; FIXME: get impure path from nix configuration.
  (setq ispell-personal-dictionary "/home/mbock/dev/config/aspell-words.pws"))


(defun cfg:nix ()
  "Nix configuration."
  ;;(require 'nix-mode)
  ;;(add-to-list 'auto-mode-alist '("\\.nix" . nix-mode))
  )


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
  (require 'smartparens-config)
  (smartparens-global-strict-mode)

  (global-set-key (kbd "C-M-<right>") 'sp-forward-sexp)
  (global-set-key (kbd "C-M-f") 'sp-forward-sexp)
  (global-set-key (kbd "C-M-<left>") 'sp-backward-sexp)
  (global-set-key (kbd "C-M-b") 'sp-backward-sexp)


  (global-set-key (kbd "C-M-w") (lambda () (interactive)
                                  (sp-mark-sexp)
                                  (sp-copy-sexp)))


  (global-set-key (kbd "C-<right>") 'sp-forward-slurp-sexp)
  (global-set-key (kbd "C-<left>") 'sp-forward-barf-sexp)

  (global-set-key (kbd "M-<left>") 'sp-backward-slurp-sexp)
  (global-set-key (kbd "M-<right>") 'sp-backward-barf-sexp))


(defun cfg:web-mode ()
  (setq web-mode-code-indent-offset 2)
  (add-hook 'web-mode-hook #'prettier-js-mode))


(defun cfg:windmove ()
  (when (fboundp 'windmove-default-keybindings)
    (windmove-default-keybindings)))


(defun cfg:haskell ()
  (with-eval-after-load 'haskell-mode
    (define-key haskell-mode-map (kbd "C-c C-x") 'haskell-process-reload)
    (setq haskell-stylish-on-save t)))

(defun cfg:helm ()
  (global-set-key (kbd "C-c f") 'helm-find))

(require 'flycheck)

(progn
  (cfg:helm)
  (cfg:simpler)
  (cfg:language)
  (cfg:startup)
  (cfg:editing)
  (cfg:direx)
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
  (cfg:windmove)
  (cfg:web-mode)
  (cfg:buffer)
  (cfg:haskell))

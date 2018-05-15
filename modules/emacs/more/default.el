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
  ;; make Emacs look less noisy.

  (setq inhibit-splash-screen t)
  (setq inhibit-startup-screen t)
  (setq inhibit-startup-message t)
  (setq initial-scratch-message "")
  (setq inhibit-startup-echo-area-message "m")
  (blink-cursor-mode 0)
  (fringe-mode 4))

(progn
  ;; Packages
  (require 'package)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
  (package-initialize))

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
  ;; Direx
  (global-set-key (kbd "C-x C-j") 'direx:jump-to-directory))


(progn
  ;; Spelling

  ;; enable spell checking for comments in all programming modes
  (add-hook 'prog-mode-hook #'flyspell-prog-mode)
  (add-hook 'text-mode-hook #'flyspell-mode)

  ;; FIXME: get impure path from nix configuration.
  (setq ispell-personal-dictionary "/home/mbock/dev/config/aspell-words.pws"))


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


  (global-set-key (kbd "C-M-w") (lambda () (interactive)
                                  (sp-mark-sexp)
                                  (sp-copy-sexp)))


  (global-set-key (kbd "C-<right>") 'sp-forward-slurp-sexp)
  (global-set-key (kbd "C-<left>") 'sp-forward-barf-sexp)

  (global-set-key (kbd "M-<left>") 'sp-backward-slurp-sexp)
  (global-set-key (kbd "M-<right>") 'sp-backward-barf-sexp))


(progn
  ;; Web Mode
  (setq web-mode-code-indent-offset 2)
  ;;(add-hook 'web-mode-hook #'prettier-js-mode)
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
        helm-recentf-fuzzy-match    t)
  (helm-mode)
  (setq helm-autoresize-max-height 30)
  (setq helm-autoresize-min-height 5)
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
          helm-source-buffer-not-found)))

(progn
  (defun load-theme--disable-old-theme(theme &rest args)
    "Disable current theme before loading new one."
    (mapcar #'disable-theme custom-enabled-themes))

  (advice-add 'load-theme :before #'load-theme--disable-old-theme))

(progn
  (add-hook 'prog-mode-hook 'highlight-indentation-mode))

(progn
  (setq browse-url-browser-function 'browse-url-generic
        browse-url-generic-program "chromium-browser"))

(progn
  (global-set-key (kbd "<C-S-up>")     'buf-move-up)
  (global-set-key (kbd "<C-S-down>")   'buf-move-down)
  (global-set-key (kbd "<C-S-left>")   'buf-move-left)
  (global-set-key (kbd "<C-S-right>")  'buf-move-right))

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
     #b00000000])

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

  (defvar acc-auto-repeat-time 100000
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


  (require 'accelerate)
  (accelerate previous-line 3)
  (accelerate next-line 3)
  (accelerate backward-char 3)
  (accelerate forward-char 3)
  (accelerate right-char 3)
  (accelerate left-char 3)
  (accelerate dired-previous-line 2)
  (accelerate dired-next-line 2))

(progn
  (autoload 'helm-company "helm-company")
  (eval-after-load 'company
    '(progn
       (define-key company-mode-map (kbd "C-:") 'helm-company)
       (define-key company-active-map (kbd "C-:") 'helm-company))))


(progn
  (require 'whitespace)
  (setq whitespace-style '(face empty tabs lines-tail trailing))
  (global-whitespace-mode t))


(progn
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)


  (global-set-key (kbd "C->") 'mc/mark-next-like-this)

  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

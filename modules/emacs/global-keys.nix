{ pkgs, config, ... }:

with pkgs.emacs25PackagesNg;
{

  programs.emacs.stanzas.global-keys.epkgs = [ magit ] ++ [ hydra ];

  programs.emacs.stanzas.global-keys.init = ''

    ${config.programs.emacs.stanzas.hydra.init}

    (global-set-key (kbd "C-x g") 'magit-status)
    (global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
    (global-set-key (kbd "C-c C-c p") 'find-file-at-point)

    (global-set-key (kbd "C-z") 'avy-goto-line-above)
    (global-set-key (kbd "C-`") 'avy-goto-line-below)

    (global-set-key (kbd "C-c r") 'replace-regexp)

    hydra-main/heads
    (global-set-key '[8711] #'hydra-main/body)


    (defvar my-keys-minor-mode-map
       (let ((map (make-sparse-keymap)))
;;         (define-key map (kbd "C-z") 'ace-jump-line-mode)
           (define-key map (kbd "C-.") 'avy-goto-char-timer)
         (define-key map (kbd "C-c c") #'comment-or-uncomment-region)
         map)
       "my-keys-minor-mode keymap.")

    (define-minor-mode my-keys-minor-mode
      "A minor mode so that my key settings override annoying major modes."
      :init-value t
      :lighter " my-keys")

    (my-keys-minor-mode 1)
  '';

}

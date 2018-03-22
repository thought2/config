{ pkgs, ... }:

with pkgs.emacs25PackagesNg;
{

  programs.emacs.stanzas.magit.epkgs = [ magit magit-gitflow ];

  programs.emacs.stanzas.magit.init = ''
    (setq exec-path (append exec-path '("${pkgs.git}/bin")))
    (setq exec-path (append exec-path '("${pkgs.gitAndTools.gitflow}/bin")))

    (require 'magit)
    (require 'magit-gitflow)

    (add-hook 'magit-mode-hook 'turn-on-magit-gitflow)

    (defun magit-delete-trailing-whitespace-from-file ()
      "Remove whitespace from the current file."
      (interactive)
      (save-excursion
        (magit-diff-visit-file-worktree (magit-file-at-point))
        (delete-trailing-whitespace)
        (save-buffer)
        (kill-buffer))
      (magit-refresh))
  '';

}

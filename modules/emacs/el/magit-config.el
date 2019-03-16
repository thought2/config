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

(add-hook 'after-save-hook 'magit-after-save-refresh-status)

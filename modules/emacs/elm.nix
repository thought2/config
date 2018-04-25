{ pkgs, ... }:

with pkgs.emacs25PackagesNg;
{

  programs.emacs.stanzas.elm.epkgs = [ flycheck elm-mode flycheck-elm ];

  programs.emacs.stanzas.elm.init = ''

    (progn
      (require 'flycheck)
      (require 'elm-mode)
      (add-hook 'after-init-hook #'global-flycheck-mode)
      (add-hook 'flycheck-mode-hook 'flycheck-elm-setup)
      (with-eval-after-load 'company
        (add-to-list 'company-backends 'company-elm))
      (add-hook 'elm-mode-hook #'company-mode)

      (setq elm-format-on-save t))


  '';

}

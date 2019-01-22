{ pkgs, ... }:

with pkgs.emacs25PackagesNg;
{

  programs.emacs.stanzas.elm.epkgs = [ flycheck elm-mode flycheck-elm smartparens ];

  programs.emacs.stanzas.elm.init = ''

    (progn
      (require 'flycheck)
      (require 'elm-mode)
      (require 'smartparens-config)

      (add-hook 'after-init-hook #'global-flycheck-mode)
      (add-hook 'flycheck-mode-hook 'flycheck-elm-setup)
      (with-eval-after-load 'company
        (add-to-list 'company-backends 'company-elm))
      (add-hook 'elm-mode-hook #'company-mode)
      (add-hook 'elm-mode-hook #'smartparens-mode)
      (add-hook 'elm-mode-hook #'camelCase-mode)

      (setq elm-format-on-save t))


  '';

}

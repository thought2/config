{ pkgs, ... }:

with pkgs.emacs25PackagesNg;

{ 

  programs.emacs.pkgs = [ magit magit-gitflow ];

  programs.emacs.init = ''
    (setq exec-path (append exec-path '("${pkgs.git}/bin")))
    (setq exec-path (append exec-path '("${pkgs.gitAndTools.gitflow}/bin")))

    (require 'magit)
    (require 'magit-gitflow)
    
    (add-hook 'magit-mode-hook 'turn-on-magit-gitflow)
  '';

  # programs.emacs.stanzas = [
  #   { pkgs = [ magit magit-gitflow ];
  #     init = ''
  #       (setq exec-path (append exec-path '("${pkgs.git}/bin")))
  #       (setq exec-path (append exec-path '("${pkgs.gitAndTools.gitflow}/bin")))

  #       (require 'magit)
  #       (require 'magit-gitflow)

  #       (add-hook 'magit-mode-hook 'turn-on-magit-gitflow)
  #     '';
  #   }
  # ];
}

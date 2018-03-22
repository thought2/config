{ pkgs, ... }:

{
  programs.emacs.stanzas.avy.epkgs = with pkgs.emacs25PackagesNg;
    [ avy ];

  programs.emacs.stanzas.avy.init = ''

    (setq avy-keys (number-sequence ?a ?z))

  '';
}

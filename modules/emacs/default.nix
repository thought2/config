{ config, lib, pkgs, ... }:

{
  imports =
    [ ../build-emacs.nix
      ./magit.nix
      ./hydra.nix
      ./more/default.nix
      ./global-keys.nix
      ./elfeed.nix
      ./elm.nix
      # ./reload-init.nix
    ];

}

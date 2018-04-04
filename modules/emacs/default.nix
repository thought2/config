{ config, lib, pkgs, ... }:

{
  imports =
    [ ../build-emacs
      ./magit.nix
      ./hydra
      ./more/default.nix
      ./global-keys.nix
      ./elfeed.nix
      ./elm.nix
      ./avy.nix
      ./no-easy-keys
    ];

}

{ config, lib, pkgs, ... }:

{
  imports =
    [ ../build-emacs.nix
      ./magit.nix
      ./hydra.nix
      ./more/default.nix
      # ./reload-init.nix
    ];

}

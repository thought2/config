{ config, lib, pkgs, ... }:

{
  imports =
    [ ./build-emacs.nix
      ./hydra.nix
      ./magit.nix
      ./more
      ./reload-init.nix
    ];

}

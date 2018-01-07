let
  overlay = import ../overlays;
  pkgs = import (import <nixpkgs> {}).path { overlays = [ overlay ]; };
in

{
  imports = [
    ./cli.nix
  ];

  services.xserver = {
    enable              = true;
    layout              = "macintosh_vndr/de";
    exportConfiguration = true;
    xkbOptions          = "eurosign:e,shift:both_capslock,caps:none";
  };

  # TODO: this should work with an overlay as well
  services.xserver.windowManager = {
    session = [{
      name = "xmonad";
      start = ''
        ${pkgs.xmonad}/bin/xmonad &
        waitPID=$!
      '';
      }];
  };
  
  services.illum.enable = true;

  services.emacs.enable = true;
  services.emacs.package = pkgs.emacs;

  sound.mediaKeys.enable = true;  
}

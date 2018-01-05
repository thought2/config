let
  overlay = import ../overlays;
  pkgs = import (import <nixpkgs> {}).path { overlays = [ overlay ]; };
in

{
  time.timeZone = "Europe/Berlin";

  environment.shellAliases = {
    "cd-tmp" = "cd $(${pkgs.coreutils}/bin/mktemp -d)";
    "cd1" = "cd ..";
    "cd2" = "cd ../..";
    "cd3" = "cd ../../..";
    "cd-" = "cd -";
  };

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
 
  users.extraUsers.mbock = {
    isNormalUser = true;
    uid = 1001;
    extraGroups = [
      "wheel"
      "networkmanager"
      "scanner"
      "audio"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqLuEaHpnBRDzqsiYC9Cv7+N62hyYQ6udABmGNz/wiHrtd4X5/QYAx0IoohGZ74nXH5atufqKDe/bWAdIxVibDImPdSCKS6b70pi3Zp0ZMqhEuLLlL+6mVFnkCA1lgHEa+s6jlD2qpuarvWQUNM0AIOEXLVdQ9FqWDUkOWBe1oH//VplkCgkCDnUNv/wxOA84BumjQBn9yF6EUb5+nmbciU9rl1C7qHbm7JuhH/FgWhBmnQFPyaea2ML0jxKXCdteSi5RzCu9XXHQO72VebQ2JvgkkU5oft9z0/fQ+wvBn1HIA2uiy3yGLc0piM1icd1PpsrnhDfW+HK2fq4SZM2Kx"
    ];
  };
  
  networking.extraHosts = ''
    46.38.233.235 netcup
  '';

  services.illum.enable = true;

  services.emacs.enable = true;
  services.emacs.package = pkgs.emacs;

  sound.mediaKeys.enable = true;  
}

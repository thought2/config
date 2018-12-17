{ config, pkgs, ... }:
with pkgs;
{
  imports =
    [
      ../../hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
}

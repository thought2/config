{ config, pkgs, ... }:
{
  imports =
    [ 
      ../../hardware-configuration.nix
    ];

  networking.hostName = "minimal-uefi";

  boot.loader.systemd-boot.enable = true;

  system.stateVersion = "18.09";
}

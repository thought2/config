{ config, pkgs, ... }:
{
  imports =
    [ 
      ../../hardware-configuration.nix
      ../modules/init.nix
    ];

  networking.hostName = "minimal-legacy";

  boot.loader.grub.device = "/dev/sda";

  system.stateVersion = "18.09";
}

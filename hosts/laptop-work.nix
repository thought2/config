{ config, pkgs, ... }:
{
  imports =
    [ ../machines/dell/configuration.nix
      ../modules/laptop.nix
      ../../coya-config/default.nix
    ];

  networking.hostName = "laptop-work";

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/nvme0n1p2";
      allowDiscards = true;
    }
  ];

  system.stateVersion = "18.03";
}

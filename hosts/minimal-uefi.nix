{ config, pkgs, ... }:
{
  imports =
    [ 
      ../../hardware-configuration.nix
      ../../extra.nix
    ];

  networking.hostName = "minimal-uefi";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "18.09";

  networking.networkmanager.enable = true;

  
}

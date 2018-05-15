{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/laptop.nix
      ../../../coya-config/default.nix
    ];

  sound.mediaKeys.enable = true;

#  sound.enable = true;

  hardware.pulseaudio.enable = true;

  boot.kernelParams = [ "intel_pstate=no_hwp" ];

  networking.networkmanager.enable = true;

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver = {
    layout              = "de";
  };

  virtualisation.virtualbox.guest.enable = true;

  virtualisation.virtualbox.host.enable = true;

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/nvme0n1p2";
      allowDiscards = true;
    }
  ];

#  services.xserver.dpi = 130;
  # services.xserver.monitorSection = "
  #  DisplaySize 423 238
  # ";

  system.stateVersion = "18.03"; # Did you read the comment?

}

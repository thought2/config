{ config, pkgs, ... }:

let
 
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;

in

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/laptop.nix
      ../../../coya-config/default.nix
    ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  sound.mediaKeys.enable = true;

  # sound.enable = true;

  hardware.pulseaudio.enable = true;

  boot.kernelParams = [ "intel_pstate=no_hwp" ];

  networking.networkmanager.enable = true;

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver = {
    layout = "us";
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

  # services.xserver.dpi = 130;
  # services.xserver.monitorSection = "
  #  DisplaySize 423 238
  # ";

  networking.firewall.allowedTCPPorts = [ 8080 3000];

  system.stateVersion = "18.03"; # Did you read the comment?

}

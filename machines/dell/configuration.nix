{ config, pkgs, ... }:

let

  # needed for purescript
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/060a98e9f4ad879492e48d63e887b0b6db26299e.tar.gz;

  unstableTarball2 =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/7df10f388dabe9af3320fe91dd715fc84f4c7e8a.tar.gz;

  oldTar =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/fcb391324f3f6dd01e59bc54e81ebf8e74db8362.tar.gz;

  latest =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/2be930cc4a891a166ee71bc353ce9af297471e2b.tar.gz;

in
with pkgs;
{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/laptop.nix
      ../../modules/webserver.nix
      ../../../coya-config/default.nix
    ];

  systemd.services.polkit.serviceConfig.X-RestartIfChanged = false;
  systemd.services.dbus.serviceConfig.X-RestartIfChanged = false;


  nixpkgs.config = {

    # allowUnfree = true;

    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
      unstable2 = import unstableTarball2 {
        config = config.nixpkgs.config;
      };
      old = import oldTar {
        config = config.nixpkgs.config;
      };
      latest = import latest {
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
    # dpi = 130;
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

  networking.firewall.allowedTCPPorts = [ 8080 3000 80 ];

  system.stateVersion = "18.09"; # Did you read the comment?

}

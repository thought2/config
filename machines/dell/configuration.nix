{ config, pkgs, ... }:
with pkgs;
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  systemd.services.polkit.serviceConfig.X-RestartIfChanged = false;
  systemd.services.dbus.serviceConfig.X-RestartIfChanged = false;

  sound.mediaKeys.enable = true;

  hardware.pulseaudio.enable = true;

  boot.kernelParams = [ "intel_pstate=no_hwp" ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}

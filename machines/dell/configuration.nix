{ config, pkgs, ... }:
with pkgs;
{
  imports =
    [ ../../../hardware-configuration.nix
    ];

  environment.systemPackages = [
    (writeShellScriptBin "dpi-high" ''
      ${pkgs.psmisc}/bin/killall chromium
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi 150
      ${pkgs.chromium}/bin/chromium
    '')
    (writeShellScriptBin "dpi-low" ''
      ${pkgs.psmisc}/bin/killall chromium
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi 90
      ${pkgs.chromium}/bin/chromium
    '')
  ];

  systemd.services.polkit.serviceConfig.X-RestartIfChanged = false;
  systemd.services.dbus.serviceConfig.X-RestartIfChanged = false;

  sound.mediaKeys.enable = true;

  boot.kernelParams = [ "intel_pstate=no_hwp" ];

  networking.networkmanager.enable = true;

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}

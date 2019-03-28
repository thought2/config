{ config, pkgs, ... }:
with pkgs;
{
  imports =
    [ ../../../hardware-configuration.nix
    ];

  environment.systemPackages = [
    (writeShellScriptBin "dpi-high" ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi 150
    '')
    (writeShellScriptBin "dpi-low" ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi 90
    '')
  ];

  systemd.services.polkit.serviceConfig.X-RestartIfChanged = false;
  systemd.services.dbus.serviceConfig.X-RestartIfChanged = false;

  sound.mediaKeys.enable = true;

  hardware.pulseaudio.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}

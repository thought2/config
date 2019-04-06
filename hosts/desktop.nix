{ config, pkgs, ... }:
{
  imports =
    [ ../machines/reteq.nix
    # ../modules/webserver.nix
      ../modules/work-station.nix
    # ../../../private-config/default.nix
    ];

  networking.hostName = "desktop";

  system.stateVersion = "18.09";

  services.xserver.desktopManager.xfce.enable = true;

  services.xserver.desktopManager.gnome3.enable = true;
}

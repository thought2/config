{ config, pkgs, ... }:
{
  imports =
    [ ../machines/reteq/configuration.nix
      ../../modules/webserver.nix
      ../../modules/work-station.nix
    # ../../../private-config/default.nix
    ];

  networking.hostName = "desktop";

  system.stateVersion = "18.09";
}

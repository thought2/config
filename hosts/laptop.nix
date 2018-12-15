{ config, pkgs, ... }:
{
  imports =
    [ ../machines/dell/configuration.nix
      ../../modules/webserver.nix
      ../../modules/laptop.nix
      ../../../private-config/default.nix
    ];

  networking.hostName = "lap";

  system.stateVersion = "18.09";
}

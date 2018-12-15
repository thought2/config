{ config, pkgs, ... }:
{
  imports =
    [
    ];

  networking.hostname = "prod";

  system.stateVersion = "18.03";
}

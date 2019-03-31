{ config, pkgs, ... }:
{
  imports =
    [ ../machines/dell/configuration.nix
      # ../modules/webserver.nix
      ../modules/laptop.nix
      # ../../../private-config/default.nix
    ];

  networking.hostName = "laptop";

  system.stateVersion = "18.09";

  hardware.cpu.intel.updateMicrocode = true;
}

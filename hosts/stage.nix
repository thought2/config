{ config, pkgs, ... }:
{
  imports =
    [ ../machines/netcup/configuration.nix
      ../modules/ssh.nix
    ];

  networking.hostName = "stage";

  system.stateVersion = "18.09";

  hardware.cpu.intel.updateMicrocode = true;
}

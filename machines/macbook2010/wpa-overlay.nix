{ lib, ... }:
{
  imports = [ ./configuration.nix ];

  networking = lib.mkOverride 1000 {
    wireless.enable = true;
    networkmanager.enable = false;
  };
}

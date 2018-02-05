{ ... }:

{
  disabledModules = [
    ../netcup/hardware-configuration.nix
  ];

  imports = [
    ../netcup/configuration.nix
    ./hardware-configuration.nix
  ];
}

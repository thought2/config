{ ... }:

{
  imports = [
    ../netcup/configuration.nix
    ../../modules/init.nix
    ./hardware-configuration.nix
  ];

  boot.loader.grub.device = "/dev/sda";
}

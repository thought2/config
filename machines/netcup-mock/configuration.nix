{ ... }:

{
  imports = [
    ../../modules/init.nix
    ./hardware-configuration.nix
  ];

  boot.loader.grub.device = "/dev/sda";
}

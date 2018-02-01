with import <nixpkgs> {};

let
  localPkgs = import ./pkgs { inherit pkgs; };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/laptop.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  hardware.bluetooth.enable = true;

  services.unclutter.enable = true;

  networking.networkmanager.enable = true;

  networking.enableB43Firmware = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = localPkgs;
}

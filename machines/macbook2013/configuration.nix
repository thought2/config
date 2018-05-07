{ pkgs, config, ... }:

with import <nixpkgs> {};

let
  localPkgs = import ./pkgs { inherit pkgs; };
  overlays = import ./overlays.nix {inherit config; };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/laptop.nix
#    ./sound-fix.nix
    ./kworker-fix.nix
    ../../modules/mac.nix
  ];

  services.xserver = {
    layout              = "macintosh_vndr/de";
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernelModules = ["sbshc" "sbs"];

  virtualisation.virtualbox.host.enable = true;

  hardware.bluetooth.enable = true;

  networking.networkmanager.enable = true;

  networking.enableB43Firmware = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = localPkgs;

  nixpkgs.overlays = [ overlays ];

}

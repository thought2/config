{ config, pkgs, ... }:

let
  overlay = import ../overlays;
  pkgs = import (import <nixpkgs> {}).path { overlays = [ overlay ]; };

  systemPackages = import ../../pkgs/minimal.nix;
in

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/work-station.nix
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

#  networking.hostName = "vm";
#  networking.wireless.enable = true;

  networking.hosts = {
    "127.0.0.1" = [ "hqrevenue.dev" ];
  };

  system.stateVersion = "17.09";

  services.openssh.enable = true;

  nix.extraOptions = ''
    binary-caches-parallel-connections = 40
  '';

  environment = {
    inherit systemPackages;
  };

  fileSystems."/mnt/home".options = ["rw" "uid=1001" "gid=100"];
}

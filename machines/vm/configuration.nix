{ config, pkgs, ... }:

let
  overlay = import ../../overlays;
  pkgs = import (import <nixpkgs> {}).path { overlays = [ overlay ]; };

  systemPkgs = import ../../pkgs/base.nix;
  localPkgs = import ./pkgs { inherit pkgs; };

in

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/hq.nix
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
    "192.168.56.101" = [ "hqrevenue.dev" ];
  };

  networking.firewall.allowedTCPPorts = [ 8000 ];
  networking.firewall.enable = true;

  system.stateVersion = "17.09";

  services.openssh.enable = true;

  nix.extraOptions = ''
#   binary-caches-parallel-connections = 40
  '';

  environment.systemPackages = systemPkgs ++ localPkgs ++ (builtins.attrValues pkgs.shorthands);

  environment.shellAliases = {
  };

  nix.sshServe.enable = true;

  fileSystems."/mnt/home".options = ["rw" "uid=1001" "gid=100"];
}

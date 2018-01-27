{ config,  lib, ... }:

with lib;

let
  overlay = import ../../overlays;
  pkgs = import (import <nixpkgs> {}).path { overlays = [ overlay ]; };

  localPkgs = import ./pkgs { inherit pkgs; };

in

rec {
  imports = [
    ../../modules/laptop.nix
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable  = true;
    version = 2;
    device  = "/dev/sda";
  };

  boot.kernelModules = ["sbshc" "sbs"];

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "rt";
    wireless.enable = false;
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [];
    firewall.enable = true;
  };

  boot.initrd.luks = {
    devices = [{
      name = "luksroot";
      device = "/dev/sda2";
    }];
    cryptoModules = [ "aes" "sha512" "sha1" "xts"];
  };

  boot.initrd.availableKernelModules =
    ["xhci_hcd" "ehci_pci" "ahci" "usb_storage"];

  networking.enableB43Firmware = true;

  system.autoUpgrade = {
    channel = "https://nixos.org/channels/nixos-17.09";
    enable  = true;
  };

  users.extraUsers.m = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
      "scanner"
      "audio"
    ];
  };

  users.extraUsers.m2 = {
    isNormalUser = true;
  };

#  nixpkgs.overlays = [ o ];


  users.extraGroups.vboxusers.members = [ "m" ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 80;
  };

  zramSwap.enable = true;

  /*systemd.services.lid-workaroud = {
    serviceConfig = {
      "Type" = "oneshot";
    };
    # https://askubuntu.com/questions/152403/how-do-i-make-changes-to-proc-acpi-wakeup-permanent#268172
    script = ''
      #!${pkgs.bash}/bin/bash
      ${pkgs.coreutils}/bin/echo LID0 >> /proc/acpi/wakeup
    '';
    wantedBy = ["multi-user.target"];
  };*/

  #services.midiController = {
  #  enable = true;
  #  userName = "m";
  #};
}

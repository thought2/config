with import <nixpkgs> {};

let
  localPkgs = import ./pkgs { inherit pkgs; };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/hq.nix
    ../../modules/laptop.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  virtualisation.virtualbox.host.enable = true;

  hardware.bluetooth.enable = true;

  networking.networkmanager.enable = true;

  networking.enableB43Firmware = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = localPkgs;

  environment.etc = {
    "asound.conf".source = pkgs.writeText "asound.conf" ''

      pcm.!default {
        type hw
        card 1
      }

      ctl.!default {
        type hw
        card 1
      }

    '';
  };

}

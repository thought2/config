{ config,  lib, ... }:
 
with lib;
 	
let
  helpers = rec {
    sepBySpace = concatStringsSep " ";
    sepByComma = concatStringsSep ",";
    sepByNewlinse = concatStringsSep "\n";
  };

  # TODO: better namings / consistency here
  pkgs = import <nixpkgs> {};
  myPkgs = import ./pkgs;
  xm = import ../../pkgs/xmonad {};
  
in with helpers; 

rec {
  imports = [
    ./hardware-configuration.nix
    ./minimal.nix
#    ./modules
  ];

  environment.systemPackages = myPkgs;

  /*
  services.xserver.windowManager.xmonad = {
    enable                 = true;
    enableContribAndExtras = true;
  };
  */

  services.xserver.windowManager = {
    session = [{
      name = "xmonad";
      start = ''
        ${xm}/bin/xmonad &
        waitPID=$!
      '';
      }];
  };
  
  hardware = {
    bluetooth.enable = true;
    #sane.enable = true;
  };
  
  virtualisation.virtualbox.host = {
    headless = true;
    enable   = true;
  };
  
  users.extraGroups.vboxusers.members = [ "m" ];
  
  time.timeZone = "Europe/Berlin";

  /*
  environment.shellAliases = with pkgs; {
    youtube-dl-mp3 = replaceChars ["\n"] [" "] ''
      ${youtube-dl}/bin/youtube-dl --extract-audio
                                   --audio-format mp3
                                   --output "%(title)s.%(ext)s"
    '';
    xclip =
      "${xclip}/bin/xclip -selection clipboard";
    rebuild = "nixos-rebuild switch";
    npm-run = "${nodejs}/bin/npm run-script";
  };
  */
  
  networking.extraHosts = ''
    46.38.233.235 netcup
  '';
  
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

  services.dbus.socketActivated = true;

  services.emacs.enable = true;

  services.illum.enable = true;
  
  #services.midiController = {
  #  enable = true;
  #  userName = "m";
  #};

  services.mpd.enable = true;
  
  services.mysql = {
    enable  = true;  
    package = pkgs.mysql;
  };
  
  sound.mediaKeys.enable = true;  
 
}

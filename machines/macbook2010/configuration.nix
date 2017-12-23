{ config,  lib, ... }:
 
with lib;
	
let
  helpers = rec {
    sepBySpace = concatStringsSep " ";
    sepByComma = concatStringsSep ",";
    sepByNewlinse = concatStringsSep "\n";
  };

#  pkgs = import ./pkgs {inherit lib; pkgs = import <nixpkgs> {};};

   pkgs = import <nixpkgs> {};
  
in with helpers; 

rec {
  imports = [
    ./hardware-configuration.nix
#    ./modules
  ];

  hardware = {
    bluetooth.enable = true;
    sane.enable = true;
  };
  
  virtualisation.virtualbox.host = {
    headless = true;
    enable   = true;
  };
  
  users.extraGroups.vboxusers.members = [ "m" ];

  networking = {
    hostName = "rt";
    #wireless.enable = true;
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [];
    firewall.enable = true;             
  };
  
  time.timeZone = "Europe/Berlin";

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
  
  networking.extraHosts = ''
    46.38.233.235 netcup
  '';
    
  environment.systemPackages = with pkgs; [
    unzip
    bc
    mpv
    surfraw
    pmutils
    cabal2nix
    nix-prefetch-git
    cabal-install
    mpc_cli
    libnotify
#    resetBattery
    pkgs.boot
    telegram-cli
    tdesktop
    html-tidy
    gcc
    racket
    termite
    autorandr
    jitsi
    acpi
    aspell
    aspellDicts.de
    aspellDicts.en
    bash
    blender
    chromium
    coreutils
    emacs
    espeak
    feh
    file
    firefox
    fish
    gdb
    ghc
    gimp
    git
    gnupg
    graphviz
    heroku    
    imagemagick
    inotify-tools
    leiningen
    libreoffice
    lm_sensors
    mysql
    nix-repl
    nixops
    nodejs
    npm2nix
    openjdk
    openssh
    openssl
    parallel
    pcre2
    pinentry
    potrace
    pstree
    python
    rfkill
    rlwrap
    roxterm
    sane-backends
    sane-frontends
    scrot
    stack
    thunderbird
    tor
    torbrowser
    torsocks
    tree
    udev
    usbutils
    vim
    virtualbox
    vlc
    wget
    which
    xclip
    xorg.xbacklight
    xorg.xmodmap
    xsane
    youtube-dl
    zeal
    zip
    jp
  ] ++ (with haskellPackages; [
    xmobar
    idris
  ]) ++ (with nodePackages; [
    gulp
    mocha
    electron
    tern
    typescript
  ]);
  
  boot.kernel.sysctl = {
    "vm.swappiness" = 80;
  };

  zramSwap.enable = true;
  
  system.autoUpgrade = {
    channel = "https://nixos.org/channels/nixos-17.03";
    enable  = true;
  };

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

  services.printing = {
    enable  = true;
    drivers = [ pkgs.gutenprint ];
  };
/*
  services.redshift = {
    enable    = false;
    latitude  = "52.0";
    longitude = "13.0";
  };
*/
  
  #services.autorandr.enable = false;

  services.xserver.xrandrHeads = [ "LVDS1" "HDMI1" ];

  #services.xserver.displayManager.sddm.enable = true;

  
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
 
  users.extraUsers.mbock = {
    isNormalUser = true;
    uid = 1001;
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
}

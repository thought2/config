with import ../util;

let
  # TODO: check, if there is a better way to import overlays
  o = import ../overlays;
  pkgs = import (import <nixpkgs> {}).path { overlays = [ o ]; };

  node2nixPkgs = import ./node2nix {};

in

with pkgs;
  
lib.flatten (builtins.attrValues {

  aliases = mkAliases {
    #elm-format = "${elmPackages.elm}/bin/elm-format-0.18";
    greyBg = "xsetroot -solid '#c5c8c9'";
    blackBg = "xsetroot -solid '#000000'";
  };

  custom = [
    notify-play
  ];

  desktop = [
    xmonad
  ];

  web = [
    tdesktop
    chromium
    firefox
    nodejs
    tor
    thunderbird
    torbrowser
    youtube-dl
  ];
  
  dev = [
    emacs
    emacs-client
    mysql
    cabal-install
    vim
    gcc
    racket
    python
    zeal
    #stack
    openjdk
    leiningen
    git
    pkgs.boot
    ghc
    #elmPackages.elm
    node2nixPkgs.elm-oracle
    node2nixPkgs.prettier
    node2nixPkgs.cross-env
    #haskellPackages.idris
    yarn
    gitAndTools.gitflow
    nodejs-8_x
    elmPackages.elm
  ];
  
  gfx = [
    blender
    imagemagick
    gimp
    graphviz
  ];
  
  nix = [
    nixops
    npm2nix
    nix-prefetch-git
    #cabal2nix
    nodePackages.node2nix
  ];
  
  system = [
    acpi
  ];
  
  cli = [
    rxvt
    fish
    bash
    coreutils
    tree
    which
    jp
    pstree
    bc
    file
    rlwrap
    inotify-tools
    libnotify
    parallel
  ];
  
  utils = [
    zip
    unzip
  ];
  
  media = [
    vlc
    scrot
    feh
    espeak
    sox
  ];
  
  office = [
    #libreoffice
    aspellDicts.de
    aspellDicts.en
    aspell
  ];
  
  crypto = [
    gnupg
  ];
  
  vm = [
    virtualbox
  ];

})

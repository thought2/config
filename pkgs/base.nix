with import <nixpkgs> {};
with import ./custom.nix;
with import ../util;

let
  node2nixPkgs = import ./node2nix {};
  xmonad' = import ./xmonad {};
in


lib.flatten (builtins.attrValues {

  aliases = mkAliases {
    #elm-format = "${elmPackages.elm}/bin/elm-format-0.18";
  };

  desktop = [
    xmonad'
  ];

  web = [
    telegram-cli
    chromium
    firefox
    nodejs
    tor
    thunderbird
    torbrowser
    youtube-dl
  ];
  
  dev = [
    emacs'
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
    #node2nixPkgs.elm-oracle
    #haskellPackages.idris
  ];
  
  gfx = [
    blender
    imagemagick
    gimp
    graphviz
  ];
  
  nix = [
    nix-repl
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
  ];
  
  office = [
    libreoffice
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

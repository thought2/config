{ pkgs, ... }:

with import ../util;

let

  node2nixPkgs = import ./node2nix {};

in

with pkgs;

lib.flatten (builtins.attrValues {

  aliases = mkAliases {
    # elm-format = "${elmPackages.elm}/bin/elm-format-0.18";
    greyBg = "xsetroot -solid '#c5c8c9'";
    blackBg = "xsetroot -solid '#000000'";
  };

  custom = [
  ];

  desktop = [
    xmonad
    xzoom
    rofi
    zathura
    # playonlinux
  ];

  web = [
    tdesktop
    chromium
    # opera
    firefox
    tor
    thunderbird
    torbrowser
    youtube-dl
  ];

  dev = [
    aws
    awscli
    aws-vault
    docker
    cloc
    travis
    emacs
    # emacs-nw
    emacs-client
    mysql
    cabal-install
    vim
    gcc
    # racket
    pythonExt
    # zeal
    stack
    openjdk
    leiningen
    git
    pkgs.boot
    ghc
    node2nixPkgs.cross-env
    node2nixPkgs.localtunnel
    # node2nixPkgs.elm-live
    # node2nixPkgs.create-elm-app
    # node2nixPkgs.pulp
    # unstable.purescript
    purescript
    node2nixPkgs.selenium-webdriver
    node2nixPkgs.ts-node
    # node2nixPkgs.elm-test
    nodePackages.prettier
    node2nixPkgs.pre-commit
    nodePackages.bower
    nodePackages.pulp
    node2nixPkgs.chalk-cli
    # nodePackages_6_x.typescript
    # haskellPackages.idris
    haskellPackages.stylish-haskell
    yarn
    chromedriver
    gitAndTools.gitflow
    nodejs-8_x
    elmPackages.elm
    # elmPackages.elm-format
    node2nixPkgs.elm-oracle
    purescript
    sbt
    swiProlog
    glslviewer
    docker
    python3Packages.notebook
    coq
    latest.rustc
    latest.cargo
    latest.rustup
    scala
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
    # cabal2nix
    nodePackages.node2nix
  ];

  system = [
    acpi
  ];

  cli = [
    jq
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
    iotop
    jnettop
  ];

  utils = [
    zip
    unzip
    pass
    psmisc # e.g. killall
    alsaUtils
    ncftp
    rxvt
    konsole
    lxterminal
    sshpass
    usbutils
  ];

  media = [
    vlc
    scrot
    feh
    espeak
    sox
  ];

  office = [
    # libreoffice
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

  security = [
    clamav
  ];

})

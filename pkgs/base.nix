{ pkgs, ... }:

with import ../util;

let

  node2nixPkgs = import ./node2nix {};

  easy-purescript = import ./easy-purescript.nix;

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
    nailgun
    gitAndTools.pre-commit
    stack2nix
    easy-purescript.purs
    dhall
    awscli
    aws-vault
    docker_compose
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
    # node2nixPkgs.elm-doc-preview
    # node2nixPkgs.elm-live
    # node2nixPkgs.create-elm-app
    # node2nixPkgs.pulp
    # unstable.purescript
    node2nixPkgs.selenium-webdriver
    # node2nixPkgs.ts-node
    # node2nixPkgs.elm-test
    nodePackages.prettier
    # node2nixPkgs.pre-commit
    node2nixPkgs.http-server
    nodePackages.bower
    nodePackages.pulp
    node2nixPkgs.chalk-cli
    nodePackages.typescript
    # haskellPackages.idris
    haskellPackages.stylish-haskell
    yarn
    chromedriver
    gitAndTools.gitflow
    nodejs-10_x
    elmPackages.elm
    elmPackages.elm-format
    # elmPackages.elm
    # elmPackages.elm-format
    # node2nixPkgs.elm-oracle
    # purescript
    sbt
    swiProlog
    glslviewer
    docker
    python3Packages.notebook
    coq
    rustc
    cargo
    rustup
    scala
    ocamlPackages.merlin
    ocaml
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
    xclip
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
    ag
    pastebinit
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

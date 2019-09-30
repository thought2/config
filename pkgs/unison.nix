{ pkgs ? import <nixpkgs> {} }:
let
  dynamic-linker = pkgs.stdenv.cc.bintools.dynamicLinker;
in
pkgs.stdenv.mkDerivation
  rec
  { name = "Unison";
    version = "M1d";
    src = pkgs.fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release%2FM1d/unison-linux64.tar.gz";
      sha256 = "0rpz40d23daad16r2s4appiay3brbk0awp38yamavlr6dh23c9ws";
    };

    buildInputs = [
      pkgs.zlib
      pkgs.gmp
      pkgs.ncurses5
    ];

    libPath = pkgs.lib.makeLibraryPath buildInputs;

    dontStrip = true;

    unpackPhase = ''
      mkdir -p $out/bin
      tar -xzf $src -C $out/bin
    '';

    installPhase = ''
      BIN="$out/bin/ucm"

      chmod u+w $BIN
      patchelf --interpreter ${dynamic-linker} --set-rpath ${libPath} $BIN
      chmod u-w $BIN
  '';
  }

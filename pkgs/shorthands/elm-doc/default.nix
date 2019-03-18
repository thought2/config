{ pkgs ? import <nixpkgs> {} }:
let
  repo = pkgs.fetchFromGitHub {
    owner = "ento";
    repo = "elm-doc";
    rev = "17c8274597987b462a636fbde9d2c8661ac691ef";
    sha256 = "0w6hl20jjdm3ya5rkbgyv7gkn1csf819dyqm4fj6x6blb08rr4wj";
    fetchSubmodules = true;
  };

  elmJs = pkgs.runCommand "compile" { buildInputs = [ pkgs.latest.elmPackages.elm ]; } ''
    TMP_DIR=`mktemp -d`
    cp -r ${repo}/vendor/package.elm-lang.org/* $TMP_DIR
    cd $TMP_DIR

    export HOME=$TMP
    elm make src/frontend/Main.elm --output=elm.js
    cp elm.js $out
  '';

  new-assets-file = pkgs.writeText "asset_tasks.py" ''
    from pathlib import Path
    import os

    tarball = Path(__file__).parent / 'assets' / 'assets.tar.gz'

    bundled_helps = [
      'assets/help/documentation-format.md',
      'assets/help/design-guidelines.md',
    ]

    bundled_assets = bundled_helps + [
      'artifacts/elm.js',
      'artifacts/LICENSE',
      'assets/favicon.ico',
      'assets/highlight/highlight.pack.js',
      'assets/highlight/LICENSE',
      'assets/highlight/styles/default.css',
      'assets/LICENSE',
      'assets/style.css',
    ]

    def extract_assets(output_path: Path):
      out=str(output_path)

      os.system(f'cp -r ${repo}/vendor/package.elm-lang.org/assets {out}')
      os.system(f'mkdir {out}/artifacts;')
      os.system(f'cp ${elmJs} {out}/artifacts/elm.js;')
  '';

  patched-repo = pkgs.runCommand "patched-repo" { } ''
    mkdir -p $out
    cp -r ${repo}/* $out;
    cd $out;

    cp -r ${./.}/requirements* .

    chmod -R 700 src

    rm src/elm_doc/asset_tasks.py

    cat ${new-assets-file} > src/elm_doc/asset_tasks.py
  '';

  remove-indirect-dependencies =
    let
      dist = pkgs.runCommand "build" {} ''
        mkdir $out
        cd $out
        cp -r ${./.}/* .
        chmod -R 700 $out
        export HOME=`mktemp -d`
        ${pkgs.nodejs}/bin/npm install
        mkdir $out/dist
        ${pkgs.latest.nodePackages.typescript}/bin/tsc -p $out --outdir $out/dist
      '';
    in
      pkgs.writeShellScriptBin "remove-indirect-dependencies" ''
        ${pkgs.nodejs}/bin/node ${dist}/dist/remove-indirect-dependencies.js $@
      '';


in
rec {
  elm-doc-original = pkgs.writeShellScriptBin "elm-doc-original" ''
    DIR=`pwd`

    TMP_DIR=`mktemp -d`

    cp -r ${patched-repo}/* $TMP_DIR

    chmod -R 700 $TMP_DIR

    cd $TMP_DIR

    CMD="cd $DIR; elm-doc $@"

    nix-shell requirements.nix --run "$CMD"

    cd $DIR
  '';

  elm-doc = pkgs.writeShellScriptBin "elm-doc" ''
    ${elm-doc-original}/bin/elm-doc-original \
      --fake-license 'BSD-3-Clause' \
      --output docs  \
      $@

    ${remove-indirect-dependencies}/bin/remove-indirect-dependencies \
      --searchJson docs/search.json \
      --output docs/search.json
  '';
}

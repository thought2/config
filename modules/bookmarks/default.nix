{ pkgs ? import <nixpkgs> {} }:
with builtins;
with pkgs;
let
  config = {
    pkgs = [];
    lnDir = "ln";
    bookmarks =
      fromJSON (readFile ./bookmarks.json);
  };

  configFile =
    writeText "config.json" (toJSON config);

  build =
    (import ./cli {}).bookmarks;
in
{
  bookmarks = writeShellScriptBin "bookmarks" ''
    export CONFIG_FILE=${configFile}
    ${build}/bin/bookmarks $@
  '';
}

with import <nixpkgs> {};
rec {
  mkAlias = name: command: writeScriptBin name ''
    #!${bash}/bin/bash
    ${command} "$@"
  '';

  mkAliases = def: builtins.attrValues (lib.mapAttrs mkAlias def);
}

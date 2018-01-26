with import <nixpkgs> {};
with lib;
rec {
  mkAlias = name: command: writeScriptBin name ''
    #!${bash}/bin/bash
    ${command}
  '';

  mkAliases = def: builtins.attrValues (lib.mapAttrs mkAlias def);

  writeBash = { name ? "script", src, help ? "no help available"}:
    writeScriptBin name ''
      #!${bash}/bin/bash -e
      if [ "$1" == "-h" ]
        then echo ${help}
        else ${src}
      fi
    '';

  mapIndexed = f: xs: zipListsWith f (range 0 (length xs)) xs;

  bin = pkg: binName: "${pkg}/bin/${binName}";

  sepBySpace = concatStringsSep " ";
  sepByColon = concatStringsSep ":";

  withPath = dependencies: text: ''
    PATH=${sepByColon (map (d: "${d}/bin") dependencies)}
    ${text}
  '';
}

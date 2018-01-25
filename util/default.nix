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

  getBin = pkg: binName: "${pkg}/bin/${binName}";

  sepBySpace = concatStringsSep " ";

  # FIXME: Upgrade to 17.9 and use the below function for writeBash
  
  #   writeTextFile {
  #     inherit name;
  #     executable = true;
  #     destination = "/bin/${name}";
  #     text = ''
  #       #!${stdenv.shell}
  #       ${text}
  #       '';
  #     checkPhase = ''
  #       ${stdenv.shell} -n $out/bin/${name}
  #     '';
  # }


}

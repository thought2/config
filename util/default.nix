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
    PATH=$PATH:${sepByColon (map (d: "${d}/bin") dependencies)}
    ${text}
  '';

  compr = f: g: x: f (g x);

  compl = f: g: x: g (f x);

  comp = compr;

  foldl1 = f: xs: foldl f (head xs) (tail xs);

  flow = fns: x: foldr id x fns;

  padLeft = len: n:
    let
      numbers = toString n;
      zeros = flow [
        (lib.concatStringsSep "")
        (map (const "0"))
        (range 1)
        (x: len - x)
        stringLength
      ] numbers;
    in
      zeros + numbers;

}

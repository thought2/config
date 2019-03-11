{ pkgs ? import <nixpkgs> {}, ... }:
rec {
  writeTypeScript = name: { dependencies ? {}}: text:
    let
      tsConfig = pkgs.writeText "tsconfig.json" ''
        {
          "compilerOptions": {
            "module": "commonjs",
            "target": "es6",
            "noImplicitAny": true,
            "strictNullChecks": true,
            "sourceMap": true,
            "typeRoots": [
              "./node_modules/@types"
            ]
          }
        }
      '';
      deps = npmInstall { inherit dependencies; };
      indexTs = pkgs.writeText "index.ts" text;
      tmp = pkgs.runCommand "tmp" {} ''
        mkdir $out
        cd $out
        cp -r ${deps}/lib/node_modules .
        cp ${tsConfig} tsconfig.json
        cp ${pkgs.writeText "pa" (builtins.toJSON { inherit dependencies; }) } package.json
        cp ${indexTs} index.ts
        mkdir $out/dist
        ${pkgs.latest.nodePackages.typescript}/bin/tsc -p $out --outdir $out/dist
        ls dist
      '';
    in
      pkgs.writeShellScriptBin name ''
        ${pkgs.nodejs}/bin/node ${tmp}/dist/index.js
      '';

  writeJavaScript = name: { dependencies ? {}}: text:
    let
      deps = npmInstall { inherit dependencies; };
      index = pkgs.writeText "index.js" text;
    in
    pkgs.writeShellScriptBin name ''
        NODE_PATH=${deps}/lib/node_modules ${pkgs.nodejs}/bin/node ${index}
      '';

  npmInstall = packageJson:
    let
      packageJsonSrc = pkgs.writeText "package.json" (builtins.toJSON packageJson);
    in
    pkgs.runCommand "npmInstall" {} ''
      mkdir -p $out
      export HOME=`mktemp -d`

      mkdir $out/lib

      cp ${packageJsonSrc} "$out/lib/package.json"

      cd $out/lib

      ${pkgs.nodejs}/bin/npm install
    '';
}

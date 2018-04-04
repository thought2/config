{ pkgs, ... }:
{
  writeJavaScript = name: text:
    pkgs.writeShellScriptBin name ''
      ${pkgs.nodejs}/bin/node ${pkgs.writeText name text} $@
    '';
}

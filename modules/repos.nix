{ config, lib, pkgs, ... }:

with lib;
with pkgs;
with import ../util;

let
  cfg = config.repos;

  repos-clean = writeShellScriptBin "repos-clean" ''
    echo ${cfg.targetDir}
  '';
in
{
  options.repos = {
    targetDir = mkOption {
      type = types.string;
      default = "repos";
    };
  };

  config.environment.systemPackages = [ repos-clean ];
}

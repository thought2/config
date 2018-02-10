{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.shorthands;
in

{
  options.shorthands = mkOption {
    type = types.attrsOf types.package;
    default = {};
  };

  config.environment.systemPackages = (attrValues cfg);

}

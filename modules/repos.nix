{ config, lib, pkgs, ... }:

with lib;
with pkgs;
with import ../util;

let
  cfg = config.repos;

  repos-clean = writeShellScriptBin "repos-clean" ''
    rm -rf ~/${cfg.targetDir}
    mkdir ~/${cfg.targetDir}
  '';

  repos-clone = writeShellScriptBin "repos-clone" (
    concatMapStrings
     (repo:
       ''
         ${git}/bin/git clone \
           git@github.com:${repo.owner}/${repo.name} \
           ~/${cfg.targetDir}/${repo.owner}/${repo.name}
       ''
     )
     cfg.clones
  );

  repos = writeShellScriptBin "repos" ''
    CMD=$1

    ${concatMapStrings (repo: ''
        cd ~/${cfg.targetDir}/${repo.owner}/${repo.name}
        eval "$CMD"
      '')
      cfg.clones
    }
    '';
in
{
  options.repos = {
    targetDir = mkOption {
      type = types.string;
      default = "repos";
    };

    clones = mkOption {
      type = types.listOf (types.submodule (
        {
          options = {
            owner = mkOption {
              type = types.string;
            };
            name = mkOption {
              type = types.string;
            };
            ssh = mkOption {
              type = types.bool;
              default = false;
            };
          };
        }
      ));
      default = [];
    };
  };

  config.environment.systemPackages = [
    repos-clean
    repos-clone
    repos
  ];
}

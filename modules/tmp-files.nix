{ config, pkgs, lib, ... }:

with lib;
with pkgs;

let
  cfg = config.services.tmp-files;

  utils = import ../util;

  date-str =
    writeShellScriptBin "date-str"
      ''
        COUNT_DAYS_AGO=${utils.shellExpand "1:-'0'"}
        date +%Y-%m-%d_%V-%a -d "$COUNT_DAYS_AGO days ago"
      '';

  tmp =
    writeShellScriptBin "tmp"
      ''
        COUNT_DAYS_AGO=${utils.shellExpand "1:-'0'"}
        DATE_STR=`${date-str}/bin/date-str $COUNT_DAYS_AGO`
        echo ~/${cfg.tmpDir}/$DATE_STR
      '';

  mk-tmp =
    writeShellScriptBin "mk-tmp"
      ''
        USERNAME=$1
        HOME_DIR=`eval echo ~$USERNAME`
        TMP_DIR=$HOME_DIR/${cfg.tmpDir}

        sleep 1

        for i in {0..9}; do
          DATE_STR=`${date-str}/bin/date-str $i`
          TARGET_DIR=$TMP_DIR/$DATE_STR
          LINK_NAME=$TMP_DIR/latest$i

          mkdir -p $TARGET_DIR 2> /dev/null
          rm -f $LINK_NAME
          ln -s $TARGET_DIR $LINK_NAME
        done

        rm -f $TMP_DIR/latest
        ln -s $TMP_DIR/latest0 $TMP_DIR/latest
      '';

  users =
    builtins.filter
      (user: user.isNormalUser)
      (builtins.attrValues config.users.extraUsers);
in
{
  options = {
    services.tmp-files = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable service.";
      };

      tmpDir = mkOption {
        type = types.string;
        default = "tmp";
        description = "Tmp dir in user's home.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.cron = {
      enable = true;
      systemCronJobs =
        map
          ({ name, ... }:
            "00 00 * * * ${name} ${mk-tmp}/bin/mk-tmp ${name}"
          )
          users;
    };

    powerManagement.powerUpCommands =
      concatMapStrings
        ({ name, ... }:
          ''sudo -H -u ${name} ${mk-tmp}/bin/mk-tmp ${name}''
        )
        users;

    environment.shellAliases = {
      "cd-tmp" = "cd ~/tmp/latest";
    };

    environment.systemPackages = [
      tmp
    ];
  };
}

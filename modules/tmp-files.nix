{ config, pkgs, lib, ... }:
with lib;
let
  utils = import ../util;

  date-str = pkgs.writeShellScriptBin "date-str" ''
    COUNT_DAYS_AGO=${utils.shellExpand "1:-'0'"}
    date +%Y-%m-%d_%V-%a -d "$COUNT_DAYS_AGO days ago"
  '';

  tmp = pkgs.writeShellScriptBin "tmp" ''
    COUNT_DAYS_AGO=${utils.shellExpand "1:-'0'"}
    DATE_STR=`${date-str}/bin/date-str $COUNT_DAYS_AGO`
    echo ~/tmp/$DATE_STR
  '';

  mk-tmp = pkgs.writeShellScriptBin "mk-tmp" ''
    COUNT_DAYS_AGO=${utils.shellExpand "1:-'0'"}
    DIR=`${tmp}/bin/tmp $COUNT_DAYS_AGO`
    mkdir -p $DIR 2> /dev/null
  '';

  ln-tmp = pkgs.writeShellScriptBin "ln-tmp" ''
    USERNAME=$1

    sleep 1

    for i in {0..9}; do
      TARGET=/home/$USERNAME/tmp/`${date-str}/bin/date-str $i`
      NAME=/home/$USERNAME/tmp/latest$i

      rm -f $NAME
      ln -s $TARGET $NAME
    done

    rm -f /home/$USERNAME/tmp/latest
    ln -s /home/$USERNAME/tmp/latest0 /home/$USERNAME/tmp/latest
  '';

  users = builtins.filter
    (user: user.isNormalUser)
    (builtins.attrValues config.users.extraUsers);
in
{
  services.cron = {
    enable = true;
    systemCronJobs =
      map
        ({ name, ... }: "00 00 * * * ${name} ${ln-tmp}/bin/ln-tmp ${name}")
        users;
  };

  powerManagement.powerUpCommands =
      concatMapStrings
        ({ name, ... }: ''${ln-tmp}/bin/ln-tmp ${name}'')
        users;

  environment.shellAliases = {
    "cd-tmp" = "cd ~/tmp/latest";
  };

  environment.systemPackages = [
    tmp
    mk-tmp
  ];
}

{ config, pkgs, lib, ... }:
let
  utils = import ../util;

  date-str = pkgs.writeShellScriptBin "date-str" ''
    COUNT_DAYS_AGO=${utils.shellExpand "1:-'0'"}
    date +%Y-%m-%d_%V-%a -d "$COUNT_DAYS_AGO days ago"
  '';

  tmp = pkgs.writeShellScriptBin "tmp" ''
    COUNT_DAYS_AGO=${utils.shellExpand "1:-'0'"}
    DATE_STR=`{date-str}/bin/date-str $COUNT_DAYS_AGO`
    echo ~/tmp/$DATE_STR
  '';

  mk-tmp = pkgs.writeShellScriptBin "mk-tmp" ''
    COUNT_DAYS_AGO=${utils.shellExpand "1:-'0'"}
    DIR=`${tmp}/bin/tmp $COUNT_DAYS_AGO`
    mkdir -p $DIR 2> /dev/null
  '';

  ln-tmp = pkgs.writeShellScriptBin "ln-tmp" ''
    USERNAME=$1

    TARGET=/home/$USERNAME/tmp/`${date-str}/bin/date-str`
    NAME=/home/$USERNAME/tmp/today
    sleep 5
    rm -f $NAME
    ln -s $TARGET $NAME
  '';

  users = builtins.filter
    (user: user.isNormalUser)
    (builtins.attrValues config.users.extraUsers);
in
{
  services.cron = {
    enable = true;
    systemCronJobs = map
      (user: "00 00 * * * ${user.name} ${ln-tmp}/bin/ln-tmp ${user.name}")
      users;
  };

  environment.shellAliases = {
    "cd-tmp" = ''
      TMP_DIR=`${tmp}/bin/tmp`; \
      mkdir -p $TMP_DIR 2> /dev/null; \
      cd $TMP_DIR
    '';
  };

  environment.systemPackages = [
    tmp
    mk-tmp
  ];
}

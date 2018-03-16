{pkgs, config, ...}:
let
  script = with pkgs; writeScript "low-power.sh" ''
    #!${bash}/bin/bash

    cd /sys/class/power_supply/BAT0

    status=$(<status)
    full=$(<charge_full)
    now=$(<charge_now)
    percent=$(($now / ($full / 100)))

    [ "$status" == "Discharging" ] && [ $percent -lt 5 ] && \
    ${pmutils}/bin/pm-suspend-hybrid

    [ "$status" == "Discharging" ] && [ $percent -lt 15 ] && \
    ${xorg.xbacklight}/bin/xbacklight -set 10 -time 1

  '';
in
{
  config.services.cron = {
    enable = true;
    systemCronJobs = [ ''* * * * * root ${script}''];
  };

  config.boot.initrd.kernelModules = [ "sbs" "sbshc" ];
}

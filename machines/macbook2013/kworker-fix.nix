{ pkgs, ... }:

# see https://sudoremember.blogspot.de/2013/05/high-cpu-usage-due-to-kworker.html

let
  fix-kworker = pkgs.writeShellScriptBin "fix-kworker" ''
    echo disable > /sys/firmware/acpi/interrupts/gpe06
  '';
in
{
  services.cron.systemCronJobs =
    [ "@reboot root ${fix-kworker}/bin/fix-kworker"];

  environment.systemPackages = [ fix-kworker ];
}

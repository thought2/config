{ pkgs, config, ... }:
let
  common = import ../../common.nix;
  extraGroups = common.extraGroups;
in
{
  users.extraUsers.mbock = {
    initialPassword = "guest";
    isNormalUser = true;
    openssh.authorizedKeys.keys = with import ../../keys.nix; [ one ];
    inherit extraGroups;
  };

  users.extraUsers.tmp = {
    initialPassword = "guest";
    isNormalUser = true;
    inherit extraGroups;
  };

  environment.loginShellInit = ''
    if [ "$USER" = "tmp" ]
    then
      rm -rf ~/*
      rm -rf ~/.*
    fi
  '';
}

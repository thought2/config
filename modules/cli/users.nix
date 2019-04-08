{ pkgs, config, ... }:
let
  extraGroups = [
    "wheel"
    "networkmanager"
    "scanner"
    "audio"
    "vboxusers"
    "docker"
  ];
in
{
  users.extraUsers.mbock = {
    initialPassword = "guest";
    isNormalUser = true;
    uid = 1001;
    openssh.authorizedKeys.keys = with import ../keys.nix; [ one ];
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

let
  common = import ../common.nix;
  extraGroups = common.extraGroups;
in
{
  users.extraUsers.mbock-pvt = {
    initialPassword = "guest";
    isNormalUser = true;
    openssh.authorizedKeys.keys = with import ./keys.nix; [ one ];
    inherit extraGroups;
  };
}

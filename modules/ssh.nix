{ pkgs ? import <nixpkgs> {}, ... }:
{
  services.openssh = {
    enable = true;
    # permitRootLogin = "yes";
    # passwordAuthentication = false;
    # challengeResponseAuthentication = false;
  };

  services.fail2ban.enable = true;
}

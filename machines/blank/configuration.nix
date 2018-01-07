{pkgs, ...}: {

  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub.device = "/dev/sda";

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
  };

  services.fail2ban.enable = true;
  
  users.extraUsers.root = {
    initialPassword = "root";
    openssh.authorizedKeys.keys = [ (import ../../keys.nix).two ];
  };

}

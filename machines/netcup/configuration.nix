{pkgs, ...}: {

  fileSystems."/" = {
    fsType = "ext4";
    device = "/dev/sda2";
  };
  
  boot.loader.grub.device = "/dev/sda";

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
  };

  services.gitDaemon = {
    enable = true;
    basePath = "/srv/git/";
    exportAll = true;
  };

  services.fail2ban.enable = true;

  networking.firewall.allowedTCPPorts = [ 80 9418];

  environment.systemPackages = with pkgs; [ git ];
        
  services.httpd = {
    enable       = true;
    adminAddr    = "me@thought2.de";
    documentRoot = pkgs.runCommand "cmd" {} ''
      mkdir $out
      echo "ding2" > $out/index.txt
    '';    
  };

}

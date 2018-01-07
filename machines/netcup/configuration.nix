{pkgs, ...}:
with import ../../util;
with builtins;
with pkgs;
let

  revisions = [
    {
      #rev = "";
      sha256 = "1pb7vljk8zdnxpk7cy8k6y2d9w102kz1ziz921pcivwbkxlfd10l";
    }
  ];

  mkOut = i: x: {
    urlPath = "/video/${toString i}";
    dir = import (pkgs.fetchgit {
      url = "git://46.38.233.235:/video.git";
      sha256 = x.sha256;
    });
  };
  
  dirs = mapIndexed mkOut revisions;

  overview = mapIndexed (i: x: {
    urlPath = x.urlPath;
    index = i;
  }) dirs;
in
{
        
  services.httpd = {
    enable       = true;
    adminAddr    = "me@thought2.de";
    documentRoot = pkgs.runCommand "cmd" {} ''
      mkdir $out
      echo "test output" > $out/index.txt
    '';
    servedFiles = [
      {
        urlPath = "/video";
        file = writeText "index.html" ''
          <h1>Revision Index</h1>
          ${concatStringsSep "\n" (map (x: "<a href=${x.urlPath}>Revision ${toString x.index}</a>") overview)}
        '';
      }
    ];
    servedDirs = [] ++ dirs;
  };

  networking.firewall.allowedTCPPorts = [ 80 ];  

  # fileSystems."/" = {
  #   fsType = "ext4";
  #   device = "/dev/sda2";
  # };
  
  # boot.loader.grub.device = "/dev/sda";

  # services.openssh = {
  #   enable = true;
  #   permitRootLogin = "yes";
  #   passwordAuthentication = false;
  #   challengeResponseAuthentication = false;
  # };

  # services.gitDaemon = {
  #   enable = true;
  #   basePath = "/srv/git/";
  #   exportAll = true;
  # };

  # services.fail2ban.enable = true;

  # environment.systemPackages = with pkgs; [ git ];

}

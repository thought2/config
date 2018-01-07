{pkgs, ...}:
{
  imports = [
    ../../modules/init.nix
    ../../modules/webserver.nix
  ];

  boot.loader.grub.device = "/dev/sda";
  
  services.gitDaemon = {
    enable = true;
    basePath = "/srv/git/";
    exportAll = true;
  };
  
  # fileSystems."/" = {
  #   fsType = "ext4";
  #   device = "/dev/sda2";
  # };
}

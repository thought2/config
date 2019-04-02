{ pkgs, config, ... }:
let
  overlay = import ../../overlays {inherit config;};
in
{
  imports = [
    ./prompt-init.nix
    ../tmp-files.nix
  ];

  services.tmp-files.enable = true;

  time.timeZone = "Europe/Berlin";
  
  environment.shellAliases = {
    "cd1" = "cd ..";
    "cd2" = "cd ../..";
    "cd3" = "cd ../../..";
    "ls1" = "ls ..";
    "ls2" = "ls ../..";
    "ls3" = "ls ../../..";
  };

  environment.variables = {
    NIXOS_ROOT = "/etc/nixos";
  };

  environment.shellInit = ''
    source ${./acd_func.sh}
  '';

  # environment.etc."set-environment".source = config.system.build.setEnvironment;

  users.extraUsers.mbock = {
    initialPassword = "guest";
    isNormalUser = true;
    uid = 1001;
    extraGroups = [
      "wheel"
      "networkmanager"
      "scanner"
      "audio"
      "vboxusers"
    ];
    openssh.authorizedKeys.keys = with import ../keys.nix; [ one ];
    home = "/home/mbock";
  };

  environment.systemPackages = with pkgs;
    [ 
      # (emacs.override {  withX = false; withGTK3 = false; })
      git 
      pstree
      which 
      coreutils
      ncftp
    ];

  nixpkgs.overlays = [ overlay ];

  #system.autoUpgrade.channel = https://nixos.org/channels/nixos-17.09;
  #system.autoUpgrade.enable = true;
}

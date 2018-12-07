{ pkgs, config, ... }:
let
  overlay = import ../overlays {inherit config; };
in
{
  time.timeZone = "Europe/Berlin";
  
  environment.shellAliases = {
    "cd-tmp" = "cd $(${pkgs.coreutils}/bin/mktemp -d)";
    "cd1" = "cd ..";
    "cd2" = "cd ../..";
    "cd3" = "cd ../../..";
    "ls1" = "ls ..";
    "ls2" = "ls ../..";
    "ls3" = "ls ../../..";
  };

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

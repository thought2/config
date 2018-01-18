{
  imports = [
    ./hardware-configuration.nix
    ../../modules/work-station.nix
  ];
  
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  nixpkgs.config.allowUnfree = true;
}

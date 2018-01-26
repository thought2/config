{
  imports = [
    ./hardware-configuration.nix
    ../../modules/work-station.nix
  ];
  
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;
}

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/laptop.nix
  ];
  
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;
}

{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  
  boot.loader.grub = {
    enable  = true;
    version = 2;
    device  = "/dev/sda";
  };
  
  boot.initrd.luks = {
    devices = [{
      name = "luksroot";
      device = "/dev/sda2";
    }];
    cryptoModules = [ "aes" "sha512" "sha1" "xts"];
  };

  boot.initrd.availableKernelModules =
    ["xhci_hcd" "ehci_pci" "ahci" "usb_storage"];

  boot.kernelModules = ["sbshc" "sbs"];

  nixpkgs.config.allowUnfree = true;
  
  networking = {
    hostName = "rt";
    #wireless.enable = true;
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [];
    firewall.enable = true;             
  };
    
  system.autoUpgrade = {
    channel = "https://nixos.org/channels/nixos-17.03";
    enable  = true;
  };
  
  services.xserver = {
    enable              = true;
    layout              = "macintosh_vndr/de";
    exportConfiguration = true;
    xkbOptions          = "eurosign:e,shift:both_capslock,caps:none";
  };

  services.xserver.synaptics = {
    enable           = true;
    dev              = "/dev/input/event*";
    minSpeed         = "0.4";
    maxSpeed         = "1.2";
    accelFactor      = "0.035";
    palmDetect       = true;
    horizontalScroll = false;
    twoFingerScroll  = true;
    additionalOptions = ''
      Option "TapButton3"      "2"
      Option "ClickPad"        "true"
      Option "SoftButtonAreas" "50% 0 82% 0 0 0 0 0"
    '';
  };

  services.xserver.windowManager.xmonad = {
    enable                 = true;
    enableContribAndExtras = true;
  };
 
  users.extraUsers.mbock = {
    isNormalUser = true;
    uid = 1001;
    extraGroups = [
      "wheel"
      "networkmanager"
      "scanner"
      "audio"
    ];
  };
  
  users.extraUsers.m = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
      "scanner"
      "audio"
    ];
  };

  users.extraUsers.m2 = {
    isNormalUser = true;
  };
}

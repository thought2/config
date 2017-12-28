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
    wireless.enable = false;
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [];
    firewall.enable = true;             
  };
    
  system.autoUpgrade = {
    channel = "https://nixos.org/channels/nixos-17.09";
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
 
  users.extraUsers.mbock = {
    isNormalUser = true;
    uid = 1001;
    extraGroups = [
      "wheel"
      "networkmanager"
      "scanner"
      "audio"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqLuEaHpnBRDzqsiYC9Cv7+N62hyYQ6udABmGNz/wiHrtd4X5/QYAx0IoohGZ74nXH5atufqKDe/bWAdIxVibDImPdSCKS6b70pi3Zp0ZMqhEuLLlL+6mVFnkCA1lgHEa+s6jlD2qpuarvWQUNM0AIOEXLVdQ9FqWDUkOWBe1oH//VplkCgkCDnUNv/wxOA84BumjQBn9yF6EUb5+nmbciU9rl1C7qHbm7JuhH/FgWhBmnQFPyaea2ML0jxKXCdteSi5RzCu9XXHQO72VebQ2JvgkkU5oft9z0/fQ+wvBn1HIA2uiy3yGLc0piM1icd1PpsrnhDfW+HK2fq4SZM2Kx"
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

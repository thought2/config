{
  time.timeZone = "Europe/Berlin";
  
  i18n = {
    consoleFont   = "Lat2-Terminus16";
    defaultLocale = "de_DE.UTF-8";
  };

  nixpkgs.config = {
   allowUnfree = true;
  };

  sound.mediaKeys.enable = true;
   
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
  
  services.xserver.windowManager.xmonad = {
    enable                 = true;
    enableContribAndExtras = true;
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

}

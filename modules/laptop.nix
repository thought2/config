{

  imports = [
    ./low-battery.nix
    ./work-station.nix
  ];

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
}

{ pkgs, lib, config, ... }:

let
  systemPkgs = import ../pkgs/base.nix { inherit pkgs; };
  shorthands = import ../pkgs/shorthands.nix { inherit pkgs; inherit config; };
in

with pkgs;
with lib;
{
  imports = [
    ./cli
    ./git.nix
    ./emacs
    ./extra-pkgs.nix
    ./dunst
    ./chromium
  ];

  networking.networkmanager.enable = true;

  # virtualisation.virtualbox.guest.enable = true;

  virtualisation.virtualbox.host.enable = true;

  users.users.root.extraGroups = [ "audio" ];

  hardware.pulseaudio.enable = true;

  services.xserver = {
    layout = "us";
    enable = true;
    exportConfiguration = true;
    xkbVariant = "altgr-intl";
    xkbOptions = "ctrl:nocaps, eurosign:e, compose:ralt";
#    xkbOptions = "eurosign:e,caps:none, keypad:pointerkeys";

    displayManager = {
      sessionCommands = ''
        ${pkgs.xorg.xmodmap}/bin/xmodmap /etc/Xmodmap
      '';
      };

  };

  # Todo: this should work with an overlay as well
  services.xserver.windowManager = {
    session = [{
      name = "xmonad";
      start = ''
        ${pkgs.xmonad}/bin/xmonad &
        waitPID=$!
      '';
      }];
  };

  services.xserver.desktopManager.gnome3.enable = true;

  # services.xserver.displayManager.lightdm = {
  #   enable = true;
  #   extraConfig = ''
  #     seats=Seat:0, Seat:1
  #   '';
  # };

  services.illum.enable = true;

  services.emacs.enable = true;

  services.emacs.package = pkgs.emacs;

  services.unclutter.enable = true;

  sound.mediaKeys.enable = true;

  environment.systemPackages = systemPkgs ++ builtins.attrValues(shorthands);

  environment.etc.Xmodmap.text = ''
    ! a key
    keycode  38 = a A a A adiaeresis Adiaeresis adiaeresis
    ! o key
    keycode  32 = o O o O odiaeresis Odiaeresis odiaeresis
    ! u key
    keycode  30 = u U u U udiaeresis Udiaeresis udiaeresis

  '';

  powerManagement.resumeCommands =
    ''
      # i3lock: Could not connect to X11, maybe you need to set DISPLAY?
      # ${pkgs.i3lock}/bin/i3lock
    '';
}

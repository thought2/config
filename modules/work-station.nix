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
    enable              = true;
    exportConfiguration = true;
    xkbOptions          = "eurosign:e,caps:none, keypad:pointerkeys";

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

  services.illum.enable = true;

  services.emacs.enable = true;

  services.emacs.package = pkgs.emacs;

  services.unclutter.enable = true;

  sound.mediaKeys.enable = true;

  environment.systemPackages = systemPkgs ++ builtins.attrValues(shorthands);

  environment.etc.Xmodmap.text = ''
    keysym a = a A a A adiaeresis Adiaeresis
    keysym o = o O o O odiaeresis Odiaeresis
    keysym u = u U u U udiaeresis Udiaeresis
    keysym s = s S s S ssharp ssharp

    clear lock
    ! Caps Lock -> Nabla
    keycode 66 = nabla

    ! only for german layout
    ! keycode 49 = asciicircum
  '';

  powerManagement.resumeCommands =
    ''
      # i3lock: Could not connect to X11, maybe you need to set DISPLAY?
      # ${pkgs.i3lock}/bin/i3lock
    '';
}
